//go:build integration

package user

import (
	"testing"

	_ "github.com/lib/pq"
)

func TestCreateUserIT(t *testing.T) {

	t.Run("create user succesfully when feature toggle is enable", func(t *testing.T) {
		t.Log("TODO: implement this test")
	})
}
