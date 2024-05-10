package config

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGetEnvariable(t *testing.T) {
	t.Run("should return value from env", func(t *testing.T) {
		key := "TEST_DATABASE_POSTGRES_URI"
		value := "postgres://user:password@localhost:4444/db"
		t.Setenv(key, value)

		assert.Equal(t, value, Env(key))
	})

	t.Run("should return empty string if env is not set", func(t *testing.T) {
		key := "TEST_DATABASE_POSTGRES_URI"

		assert.Equal(t, "", Env(key))
	})
}

func TestSetPrefix(t *testing.T) {
	t.Run("should return empty string if env is empty", func(t *testing.T) {
		env := ""
		assert.Equal(t, "", prefix(env))
	})

	t.Run("should return prefix with underscore if env is not empty", func(t *testing.T) {
		env := "TEST"
		assert.Equal(t, "TEST_", prefix(env))
	})
}

func TestParseConfig(t *testing.T) {
	t.Run("should parse config from env only once", func(t *testing.T) {
		t.Setenv("TEST_DATABASE_POSTGRES_URI", "postgres://user:password@localhost:5432/db")
		t.Setenv("TEST_SERVER_PORT", "8080")
		t.Setenv("TEST_ENABLE_CREATE_SPENDER", "true")

		cfg := Parse("TEST")

		assert.Equal(t, "postgres://user:password@localhost:5432/db", cfg.PostgresURI())
		assert.Equal(t, "8080", cfg.Server.Port)
		assert.Equal(t, true, cfg.FeatureFlag.EnableCreateSpender)

		t.Setenv("TEST_DATABASE_POSTGRES_URI", "new value")
		t.Setenv("TEST_SERVER_PORT", "new value")
		t.Setenv("TEST_ENABLE_CREATE_SPENDER", "false")

		cfg = Parse("TEST")

		assert.Equal(t, "postgres://user:password@localhost:5432/db", cfg.PostgresURI())
		assert.Equal(t, "8080", cfg.Server.Port)
		assert.Equal(t, true, cfg.FeatureFlag.EnableCreateSpender)
	})
}

func TestPrivateParseConfig(t *testing.T) {
	t.Run("should return error if required env is not set", func(t *testing.T) {
		os.Unsetenv("TEST_DATABASE_POSTGRES_URI")

		_, err := parse("TEST")

		assert.Error(t, err)
		assert.Equal(t, "failed to parse database config:env: required environment variable \"TEST_DATABASE_POSTGRES_URI\" is not set", err.Error())
	})
}
