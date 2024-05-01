FROM golang:1.21.9-bullseye as builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM gcr.io/distroless/base-debian10

USER nonroot

COPY --from=builder /app/app /

CMD ["/app"]
