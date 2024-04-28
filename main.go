package main

import (
	"log"
	"net/http"
	"os"
)

func main() {
	err := run()

	if err != http.ErrServerClosed {
		log.Fatalf("error: %v", err)
	}
}

func run() error {
	mux := http.NewServeMux()
	mux.HandleFunc("/api/v1/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"status": "UP"}`))
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	srv := &http.Server{
		Addr:    ":" + port,
		Handler: mux,
	}

	log.Printf("Server listening on port %s", port)
	return srv.ListenAndServe()
}
