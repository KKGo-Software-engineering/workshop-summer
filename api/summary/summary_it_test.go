//go:build integration

package summary

import (
	"database/sql"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/KKGo-Software-engineering/workshop-summer/api/config"
	"github.com/KKGo-Software-engineering/workshop-summer/migration"
	"github.com/labstack/echo/v4"
	_ "github.com/lib/pq"
	"github.com/stretchr/testify/assert"
)

func TestExpenseSummaryIT(t *testing.T) {
	t.Run("get expense summary successfully", func(t *testing.T) {
		sql, err := getTestDatabaseFromConfig()
		if err != nil {
			t.Error(err)
		}
		migration.ApplyMigrations(sql)
		defer migration.RollbackMigrations(sql)

		h := New(sql)
		e := echo.New()
		defer e.Close()

		e.GET("/expenses/summary", h.GetExpenseSummary)

		req := httptest.NewRequest(http.MethodGet, "/expenses/summary", nil)
		q := req.URL.Query()
		q.Add("spender_id", "1")
		req.URL.RawQuery = q.Encode()
		rec := httptest.NewRecorder()

		e.ServeHTTP(rec, req)

		assert.Equal(t, http.StatusOK, rec.Code)
		assert.JSONEq(t, `{"TotalExpenses": 0}`, rec.Body.String())
	})
}

func getTestDatabaseFromConfig() (*sql.DB, error) {
	cfg := config.Parse("DOCKER")
	sql, err := sql.Open("postgres", cfg.PostgresURI())
	if err != nil {
		return nil, err
	}
	return sql, nil
}
