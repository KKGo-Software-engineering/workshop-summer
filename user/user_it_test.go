//go:build integration

package user

import (
	"database/sql"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/KKGo-Software-engineering/workshop-summer/config"
	"github.com/labstack/echo/v4"
	_ "github.com/lib/pq"
	"github.com/stretchr/testify/assert"
)

func TestCreateUserIT(t *testing.T) {

	t.Run("create user succesfully when feature toggle is enable", func(t *testing.T) {
		cfg := config.C("DOCKER")
		sql, err := sql.Open("postgres", cfg.DBURL())
		if err != nil {
			t.Error(err)
		}

		h := New(FeatureFlag{EnableCreateUser: true}, sql)
		e := echo.New()
		defer e.Close()

		e.POST("/users", h.Create)

		payload := `{"name": "HongJot", "email": "hong@jot.ok"}`
		req := httptest.NewRequest(http.MethodPost, "/users", strings.NewReader(payload))
		req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
		rec := httptest.NewRecorder()

		e.ServeHTTP(rec, req)

		assert.Equal(t, http.StatusCreated, rec.Code)
		assert.NotEmpty(t, rec.Body.String())
	})
}
