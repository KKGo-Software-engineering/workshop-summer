# Graceful Shutdown

```graceful.go
package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)

	go func() {
		<-c
		fmt.Println("\nGracefully shutting down...")
		time.Sleep(2 * time.Second)
		os.Exit(0)
	}()

	fmt.Println("Starting server...")
	time.Sleep(60 * time.Second)
	fmt.Println("Server started")
}
```


## Test

```
	UID   PID  PPID   C STIME   TTY        TIME CMD
  501 35855 35833   0  2:44PM ttys000    0:00.21 go run graceful.go
  501 35890 35855   0  2:44PM ttys000    0:00.01 /var/folders/mc/gw44sc2j77q_gjtq_zjbyb9h0000gn/T/go-build1756379446/b001/exe/main
```

```shell
kill -SIGINT 35890
```
