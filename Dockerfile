FROM golang:1.20-alpine AS build
WORKDIR /tmp/build
ENV CGO_ENABLED=0
COPY go.mod go.sum /tmp/build
RUN go mod download && go mod verify
COPY ./cmd /tmp/build/cmd
RUN go build -v -o commit-status-poster cmd/commit-status-poster/main.go
FROM scratch
USER 1000:1000
COPY --chown=0:0 --chmod=001 --from=build /tmp/build/commit-status-poster /commit-status-poster
ENTRYPOINT ["/commit-status-poster"]
