package user

import (
	"database/sql"
	"net/http"

	"github.com/kkgo-software-engineering/workshop/mlog"
	"github.com/labstack/echo/v4"
	"go.uber.org/zap"
)

type User struct {
	ID    int64  `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

type FeatureFlag struct {
	EnableCreateUser bool `json:"enableCreateUser"`
}

type handler struct {
	cfg FeatureFlag
	db  *sql.DB
}

func New(cfg FeatureFlag, db *sql.DB) *handler {
	return &handler{cfg, db}
}

const (
	cStmt = `INSERT INTO "user" (name, email) VALUES ($1, $2) RETURNING id;`
)

func (h handler) Create(c echo.Context) error {
	if !h.cfg.EnableCreateUser {
		return c.JSON(http.StatusForbidden, "create new user feature is disabled")
	}

	logger := mlog.L(c)
	ctx := c.Request().Context()
	var ur User
	err := c.Bind(&ur)
	if err != nil {
		logger.Error("bad request body", zap.Error(err))
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	var lastInsertId int64
	err = h.db.QueryRowContext(ctx, cStmt, ur.Name, ur.Email).Scan(&lastInsertId)
	if err != nil {
		logger.Error("query row error", zap.Error(err))
		return c.JSON(http.StatusInternalServerError, err.Error())
	}

	logger.Info("create successfully", zap.Int64("id", lastInsertId))
	ur.ID = lastInsertId
	return c.JSON(http.StatusCreated, ur)
}
