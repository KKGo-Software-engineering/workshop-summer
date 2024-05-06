package config

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"sync"

	"github.com/caarlos0/env/v10"
)

type Config struct {
	Database Database
	Server   Server
}

func (c Config) PostgresURI() string {
	return c.Database.PostgresURI
}

type Server struct {
	Port string
}

type Database struct {
	PostgresURI string `env:"DATABASE_POSTGRES_URI,required"`
}

func Env(key string) string {
	value := os.Getenv(key)
	if value == "" {
		log.Fatal("Environment variable " + key + " is not set")
	}

	return value
}

func ToBoolean(strVal string) bool {
	boolVal, _ := strconv.ParseBool(strVal)
	return boolVal
}

var once sync.Once
var config Config

func C(envPrefix ...string) Config {
	if len(envPrefix) > 1 {
		log.Fatal("can pass only one prefix for env but your prefix:", envPrefix)
	}

	once.Do(func() {
		var prefix string
		if len(envPrefix) == 1 {
			prefix = fmt.Sprintf("%s_", envPrefix[0])
		}

		opts := env.Options{
			Prefix: prefix,
		}

		dbconf := &Database{}
		if err := env.ParseWithOptions(dbconf, opts); err != nil {
			log.Fatal(err)
		}

		port := os.Getenv("PORT")
		if port == "" {
			port = "8080"
		}

		config = Config{
			Database: Database{
				PostgresURI: dbconf.PostgresURI,
			},
			Server: Server{
				Port: port,
			},
		}
	})

	return config
}
