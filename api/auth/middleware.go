package auth

import (
	"crypto/subtle"
)

func Check(username, password string) bool {
	isUserValid := subtle.ConstantTimeCompare([]byte(username), []byte("user")) == 1
	isPassValid := subtle.ConstantTimeCompare([]byte(password), []byte("secret")) == 1

	return isUserValid && isPassValid
}
