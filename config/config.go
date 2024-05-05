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

func (c Config) DBURL() string {
	return fmt.Sprintf("postgresql://%s:%s@%s:5432/%s?sslmode=disable", c.Database.Username, c.Database.Password, c.Database.Host, c.Database.Name)
}

type Server struct {
	Port string
}

type Database struct {
	Host     string `env:"DATABASE_HOST,required"`
	Name     string `env:"DATABASE_NAME,required"`
	Username string `env:"DATABASE_USERNAME,required"`
	Password string `env:"DATABASE_PASSWORD,required"`
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
				Host:     dbconf.Host,
				Name:     dbconf.Name,
				Username: dbconf.Username,
				Password: dbconf.Password,
			},
			Server: Server{
				Port: port,
			},
		}
	})

	return config
}
