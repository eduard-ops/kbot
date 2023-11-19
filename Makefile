APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=eduard-ops
VERSION: $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64

lint:
    golangci-lint run

test:
    go test -v

get:
    go get

format:
    gofmt -s -w ./

build: format
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X=github.com/eduard-ops/kbot/cmd.appVersion=${VERSION}"	

image:
    docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
    docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
clean:
    rm -rf kbot