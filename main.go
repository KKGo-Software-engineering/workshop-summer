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

	"github.com/labstack/echo/v4"
	"github.com/labstack/gommon/log"
	_ "github.com/proullon/ramsql/driver"
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
	// inmemory db ramql
	db, err := sql.Open("ramsql", "TestGormQuickStart")
	if err != nil {
		log.Fatal(err)
	}

	// create table
	_, err = db.Exec(`CREATE TABLE users (
			id SERIAL PRIMARY KEY,
			name VARCHAR(50) NOT NULL,
			email VARCHAR(50) NOT NULL
		)`)

	if err != nil {
		log.Fatal(err)
	}

	e := run(db)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	go func() { // comment here to simulate slow endpoint then Ctrl+C to stop the server
		if err := e.Start(":" + port); err != nil && err != http.ErrServerClosed {
			e.Logger.Fatal("shutting down the server:", err)
		}
	}()

	e.Logger.Infof("Server is running on :%s", port)

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

func Health(c echo.Context) error {
	return c.JSON(http.StatusOK, map[string]string{"status": "ok"})
}

func GetAllUsers(db *sql.DB) echo.HandlerFunc {
	return func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{"message": "get all users"})
	}
}

func run(db *sql.DB) *echo.Echo {
	e := echo.New()
	e.Logger.SetLevel(log.INFO)

	v1 := e.Group("/api/v1")

	v1.GET("/slow", Slow)
	v1.GET("/health", Health)
	v1.POST("/upload", UploadESlip)
	v1.GET("/users", GetAllUsers(db))

	return e
}
