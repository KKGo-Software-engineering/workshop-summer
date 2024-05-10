package health

import (
	"database/sql"
	"fmt"
	"net/http"
	"time"

	"github.com/labstack/echo/v4"
)

func Check(db *sql.DB) func(c echo.Context) error {
	return func(c echo.Context) error {
		if err := db.Ping(); err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{
				"status":  "error",
				"message": fmt.Sprintf("api server is live: but can't connect to database: %s", err.Error())})
		}

		return c.JSON(http.StatusOK, map[string]string{
			"status":  "ok",
			"message": "api is ready and connected to database"})
	}
}

// Slow is for Demo purpose to simulate slow endpoint
func Slow(c echo.Context) error {
	fmt.Println("simulate slow end that takes 10 seconds to respond")
	time.Sleep(10 * time.Second)
	return c.JSON(http.StatusOK, map[string]string{"status": "ok"})
}
