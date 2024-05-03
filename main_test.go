package main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

func TestHealth(t *testing.T) {
	req, _ := http.NewRequest(http.MethodGet, "/health", nil)
	rec := httptest.NewRecorder()
	e := echo.New()
	c := e.NewContext(req, rec)

	err := Health(c)

	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, rec.Code)
}
