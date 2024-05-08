FROM golang:1.21.9-bullseye AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod tidy

COPY . ./

RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM gcr.io/distroless/base-debian12

USER nonroot

COPY --from=builder /app/app /

CMD ["/app"]
