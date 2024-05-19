FROM golang:alpine AS builder

LABEL stage=gobuilder

ENV CGO_ENABLED=0

RUN apk update --no-cache && apk add --no-cache tzdata

WORKDIR /build

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY .. .

RUN go build -ldflags="-s -w" -o /app/main server/server.go

FROM scratch

WORKDIR /app

COPY --from=builder /app/main /app/main

EXPOSE 8000

CMD ["./main"]