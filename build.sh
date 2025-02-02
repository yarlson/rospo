#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

VERSION=${VERSION:=development}

build() {
    EXT=""
    [[ $GOOS = "windows" ]] && EXT=".exe"
    echo "Building ${GOOS} ${GOARCH}"
    go build \
        -ldflags="-X 'github.com/ferama/rospo/cmd.Version=$VERSION'" \
        -o ./bin/rospo-${GOOS}-${GOARCH}${EXT} .
}

### test units
# prevent complaining about ui build dir
mkdir -p pkg/web/ui/build && touch pkg/web/ui/build/test 
go clean -testcache
go test ./... -v -cover -race || exit 1

### build ui
cd $DIR/pkg/web/ui && npm install && npm run build && cd $DIR

### multi arch binary build
GOOS=linux GOARCH=arm build
GOOS=linux GOARCH=arm64 build
GOOS=linux GOARCH=amd64 build

GOOS=darwin GOARCH=arm64 build

GOOS=windows GOARCH=amd64 build