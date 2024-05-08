package main

import (
	"database/sql"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
	_ "github.com/proullon/ramsql/driver"
	"github.com/stretchr/testify/assert"
)

func TestHealth(t *testing.T) {
	req, _ := http.NewRequest(http.MethodGet, "/health", nil)
	rec := httptest.NewRecorder()
	e := echo.New()
	c := e.NewContext(req, rec)

	db, _ := sql.Open("ramsql", "TestHealth")

	err := Health(db)(c)

	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, rec.Code)
}
