# react frontend builder
FROM node:16-alpine as uibuilder
WORKDIR /src
COPY pkg/web/ui .
RUN npm install && npm run build

# go backend builder
FROM golang:1.16 as gobuilder
ARG VERSION=development
WORKDIR /go/src/app
COPY . .
COPY --from=uibuilder /src/build pkg/web/ui/build
RUN go build \
    -ldflags="-X 'github.com/ferama/rospo/cmd.Version=$VERSION'" \
    -o /rospo .

# Final docker image
FROM ubuntu:latest
COPY --from=gobuilder /rospo /usr/local/bin/rospo