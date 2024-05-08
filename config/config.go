package config

import (
	"errors"
	"fmt"
	"log"
	"os"
	"sync"

	"github.com/caarlos0/env/v10"
)

type Config struct {
	Database    Database
	Server      Server
	FeatureFlag FeatureFlag
}

func (c Config) PostgresURI() string {
	return c.Database.PostgresURI
}

type Server struct {
	Port string `env:"SERVER_PORT"`
}

type Database struct {
	PostgresURI string `env:"DATABASE_POSTGRES_URI,required"`
}

type FeatureFlag struct {
	EnableCreateSpender bool `env:"ENABLE_CREATE_SPENDER"`
}

func Env(key string) string {
	value := os.Getenv(key)
	if value == "" {
		log.Println("Environment variable " + key + " is not set")
	}

	return value
}

var once sync.Once
var config Config

func Get() Config {
	return config
}

func prefix(env string) string {
	if env != "" {
		return fmt.Sprintf("%s_", env)
	}

	return ""
}

func parse(envPrefix string) (Config, error) {
	opts := env.Options{
		Prefix: prefix(envPrefix),
	}

	dbconf := &Database{}
	if err := env.ParseWithOptions(dbconf, opts); err != nil {
		return Config{}, errors.New("failed to parse database config:" + err.Error())
	}

	feats := &FeatureFlag{}
	if err := env.ParseWithOptions(feats, opts); err != nil {
		return Config{}, errors.New("failed to parse feature flag config:" + err.Error())
	}

	port := Env("PORT")
	if port == "" {
		port = "8080"
	}

	return Config{
		Database: Database{
			PostgresURI: dbconf.PostgresURI,
		},
		Server: Server{
			Port: port,
		},
		FeatureFlag: FeatureFlag{
			EnableCreateSpender: feats.EnableCreateSpender,
		},
	}, nil
}

func Parse(envPrefix string) Config {
	once.Do(func() {
		var err error
		config, err = parse(envPrefix)
		if err != nil {
			log.Panic(err)
		}
	})

	return config
}
