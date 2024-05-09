package main

import (
	"context"
	"database/sql"
	"fmt"
	"mime/multipart"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"time"

	"github.com/KKGo-Software-engineering/workshop-summer/config"
	"github.com/KKGo-Software-engineering/workshop-summer/migration"
	"github.com/KKGo-Software-engineering/workshop-summer/spender"
	"github.com/labstack/echo/v4"
	"github.com/labstack/gommon/log"
	_ "github.com/lib/pq"
)

func UploadToS3(c echo.Context, filename string, src multipart.File) (string, error) {
	// Assume that the file is uploaded to S3 bucket successfully
	return "location/on/s3/bucket/" + filename, nil
	// Create an AWS session
	// sess, err := session.NewSession(&aws.Config{
	// 	Region: aws.String(os.Getenv("AWS_REGION")),
	// })
	// if err != nil {
	// 	return "", err
	// }

	// Upload the file to S3
	// result, err = s3.New(sess).PutObject(&s3.PutObjectInput{
	// 	Bucket: aws.String(os.Getenv("AWS_BUCKET")),
	// 	Key:    aws.String(filename),
	// 	Body:   src,
	// })
	// if err != nil {
	// 	return "", err
	// }

	// return result.Location, nil
}

func UploadESlip(c echo.Context) error {
	form, err := c.MultipartForm()
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{
			"message": "Failed to parse form",
			"error":   err.Error(),
		})
	}
	images := form.File["images"]
	var locations []string
	for _, image := range images {
		fmt.Printf("Uploading file: %+v\n", image.Filename)
		src, err := image.Open()
		if err != nil {
			return c.JSON(http.StatusBadRequest, map[string]string{
				"message": "Failed to parse form",
				"error":   err.Error(),
			})
		}
		defer src.Close()

		// upload to AWS S3 bucket
		loc, err := UploadToS3(c, image.Filename, src)
		if err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{
				"message": "Failed to upload image",
				"error":   err.Error(),
			})
		}
		locations = append(locations, loc)
	}

	return c.JSON(http.StatusOK, map[string]string{
		"message":   "Image uploaded successfully",
		"locations": strings.Join(locations, ","),
	})
}

func main() {
	env := config.Env("ENV")
	cfg := config.Parse(env)

	db, err := sql.Open("postgres", cfg.Database.PostgresURI)
	if err != nil {
		log.Fatal(err)
	}
	if err := migration.ApplyMigrations(db); err != nil {
		log.Fatal(err)
	}

	e := run(db, cfg)

	go func() { // comment here to simulate slow endpoint then Ctrl+C to stop the server
		if err := e.Start(":" + cfg.Server.Port); err != nil && err != http.ErrServerClosed {
			e.Logger.Fatal("shutting down the server:", err)
		}
	}()

	e.Logger.Infof("Server is running on :%s", cfg.Server.Port)

	// Wait for interrupt signal to gracefully shutdown the server with a timeout of 10 seconds.
	sig, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	<-sig.Done()

	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	if err := e.Shutdown(ctx); err != nil {
		e.Logger.Fatal(err)
	}
	e.Logger.Info("server shutdown gracefully")
}

func Slow(c echo.Context) error {
	fmt.Println("simulate slow end that takes 10 seconds to respond")
	time.Sleep(10 * time.Second)
	return c.JSON(http.StatusOK, map[string]string{"status": "ok"})
}

func Health(db *sql.DB) func(c echo.Context) error {
	return func(c echo.Context) error {
		if err := db.Ping(); err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{
				"status":  "error",
				"message": fmt.Sprintf("api server is live: but can't connect to database: %s", err.Error())})
		}

		return c.JSON(http.StatusOK, map[string]string{
			"status":  "ok",
			"message": "api is ready and connected to database"})
	}
}

func run(db *sql.DB, cfg config.Config) *echo.Echo {
	e := echo.New()
	e.Logger.SetLevel(log.INFO)

	v1 := e.Group("/api/v1")

	v1.GET("/slow", Slow)
	v1.GET("/health", Health(db))
	v1.POST("/upload", UploadESlip)

	{
		h := spender.New(cfg.FeatureFlag, db)
		v1.GET("/spenders", h.GetAll)
		v1.POST("/spenders", h.Create)
	}

	return e
}
