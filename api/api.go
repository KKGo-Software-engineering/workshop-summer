package api

import (
	"database/sql"

	"github.com/KKGo-Software-engineering/workshop-summer/api/config"
	"github.com/KKGo-Software-engineering/workshop-summer/api/eslip"
	"github.com/KKGo-Software-engineering/workshop-summer/api/health"
	"github.com/KKGo-Software-engineering/workshop-summer/api/spender"
	"github.com/labstack/echo/v4"
)

func New(db *sql.DB, cfg config.Config) *echo.Echo {
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
