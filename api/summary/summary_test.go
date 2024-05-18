package summary

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

func TestGetExpenseSummary(t *testing.T) {
	t.Run("get spender expenses summary", func(t *testing.T) {
		e := echo.New()
		defer e.Close()

		req := httptest.NewRequest(http.MethodGet, "/", nil)
		req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
		q := req.URL.Query()
		q.Add("spender_id", "1")
		req.URL.RawQuery = q.Encode()
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)

		db, mock, _ := sqlmock.New(sqlmock.QueryMatcherOption(sqlmock.QueryMatcherEqual))
		defer db.Close()

		rows := sqlmock.NewRows([]string{"amount"}).
			AddRow(100).
			AddRow(50)
		mock.ExpectQuery(`SELECT amount FROM transaction WHERE spender_id = $1 AND transaction_type = 'expense'`).WillReturnRows(rows)
		h := New(db)
		err := h.GetExpenseSummary(c)

		assert.NoError(t, err)
		assert.Equal(t, http.StatusOK, rec.Code)
		assert.JSONEq(t, `{"TotalExpenses": 150}`, rec.Body.String())
	})

	t.Run("get expense summar failed on database", func(t *testing.T) {
		e := echo.New()
		defer e.Close()

		req := httptest.NewRequest(http.MethodGet, "/", nil)
		rec := httptest.NewRecorder()
		c := e.NewContext(req, rec)

		db, mock, _ := sqlmock.New(sqlmock.QueryMatcherOption(sqlmock.QueryMatcherEqual))
		defer db.Close()

		mock.ExpectQuery(`SELECT amount FROM transaction WHERE spender_id = $1 AND transaction_type = 'expense'`).WillReturnError(assert.AnError)

		h := New(db)
		err := h.GetExpenseSummary(c)

		assert.NoError(t, err)
		assert.Equal(t, http.StatusInternalServerError, rec.Code)
	})
}
