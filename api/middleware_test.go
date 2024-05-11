package api

import (
	"encoding/base64"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/stretchr/testify/assert"
)

func TestAuthMiddleware(t *testing.T) {
	tests := []struct {
		auth           string
		wantStatusCode int
	}{
		{"user:secret", http.StatusOK},
		{"user:wrong-secret", http.StatusUnauthorized},
	}

	for _, tc := range tests {
		e := echo.New()
		e.Use(middleware.BasicAuth(AuthCheck))
		e.GET("/", func(c echo.Context) error { return c.String(http.StatusOK, "[]") })
		req := httptest.NewRequest(http.MethodGet, "/", nil)
		auth := "basic " + base64.StdEncoding.EncodeToString([]byte(tc.auth))
		req.Header.Set(echo.HeaderAuthorization, auth)
		rec := httptest.NewRecorder()

		e.ServeHTTP(rec, req)

		assert.Equal(t, tc.wantStatusCode, rec.Code)
	}
}
