package main

import (
    "encoding/json"
    "fmt"
    "log"
    "net/http"
)

type Simple struct {
    Name        string
    Description string
    Url         string
}

func SimpleFactory(host string) Simple {
    return Simple{"Hello", "World", host}
}

func handler(w http.ResponseWriter, r *http.Request) {
    simple := SimpleFactory(r.Host)

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(simple)
}

func main() {
    fmt.Println("Server started on port 4444")
    http.HandleFunc("/", handler)
    log.Fatal(http.ListenAndServe(":4444", nil))
}
