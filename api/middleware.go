package api

import (
	"github.com/KKGo-Software-engineering/workshop-summer/api/auth"
	"github.com/labstack/echo/v4"
)

func AuthCheck(username, password string, c echo.Context) (bool, error) {
	isPass := auth.Check(username, password)
	return isPass, nil
}
