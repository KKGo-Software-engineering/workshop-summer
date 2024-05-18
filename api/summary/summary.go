package summary

import (
	"database/sql"
	"net/http"
	"strconv"

	"github.com/KKGo-Software-engineering/workshop-summer/api/mlog"
	"github.com/labstack/echo/v4"
	"go.uber.org/zap"
)


type handler struct {
    db *sql.DB
}


const (
    exprenseStmt = `SELECT amount FROM transaction WHERE spender_id = $1 AND transaction_type = 'expense'`
)


func New(db *sql.DB) *handler {
    return &handler{db}
}


func (h handler) GetExpenseSummary(c echo.Context) error {
    var query struct {
        ID int `query:"spender_id"`
    }
    c.Bind(&query)
    logger := mlog.L(c)
    ctx := c.Request().Context()
    logger.Info(strconv.Itoa(query.ID))


    rows, err := h.db.QueryContext(ctx, exprenseStmt, query.ID)


    Totalamount := 0.0
    if err != nil {
        logger.Error("query error", zap.Error(err))
        return c.JSON(http.StatusInternalServerError, err.Error())
    }
    defer rows.Close()


    for rows.Next() {
        var amount float64
        err := rows.Scan(&amount)
        if err != nil {
            logger.Error("scan error", zap.Error(err))
            return c.JSON(http.StatusInternalServerError, err.Error())
        }
        Totalamount += amount
    }


    return c.JSON(http.StatusOK, struct{ TotalExpenses float64 }{Totalamount})
}


