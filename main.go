package main

import (
	"context"
	"database/sql"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/KKGo-Software-engineering/workshop-summer/api/config"
	"github.com/KKGo-Software-engineering/workshop-summer/api/eslip"
	"github.com/KKGo-Software-engineering/workshop-summer/api/health"
	"github.com/KKGo-Software-engineering/workshop-summer/api/spender"
	"github.com/KKGo-Software-engineering/workshop-summer/migration"
	"github.com/kkgo-software-engineering/workshop/mlog"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/labstack/gommon/log"
	_ "github.com/lib/pq"
	"go.uber.org/zap"
)

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

	logger, err := zap.NewProduction()
	if err != nil {
		log.Fatal(err)
	}

	e := run(db, cfg)

	e.Use(middleware.Logger())
	e.Use(mlog.Middleware(logger))

	go func() { // comment here to simulate slow endpoint then Ctrl+C to stop the server
		if err := e.Start(":" + cfg.Server.Port); err != nil && err != http.ErrServerClosed {
			logger.Fatal("shutting down the server:", zap.Error(err))
		}
	}()

	logger.Info("Server is running on :%s", zap.String("port", cfg.Server.Port))

	// Wait for interrupt signal to gracefully shutdown the server with a timeout of 10 seconds.
	sig, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	<-sig.Done()

	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	if err := e.Shutdown(ctx); err != nil {
		logger.Fatal("shutting down the server:", zap.Error(err))
	}
	logger.Info("server shutdown gracefully")
}

func run(db *sql.DB, cfg config.Config) *echo.Echo {
	e := echo.New()

	v1 := e.Group("/api/v1")

	v1.GET("/slow", health.Slow)
	v1.GET("/health", health.Check(db))
	v1.POST("/upload", eslip.Upload)

	{
		h := spender.New(cfg.FeatureFlag, db)
		v1.GET("/spenders", h.GetAll)
		v1.POST("/spenders", h.Create)
	}

	return e
}
