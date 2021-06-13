FROM golang:1.16.5-alpine AS build

COPY ./ /go/src/github.com/hyperledger/external-builder
WORKDIR /go/src/github.com/hyperledger/external-builder

# Build application
RUN go get -d -v ./...
RUN go install -v ./...
RUN go build -o chaincode -v .

# Production ready image
# Pass the binary to the prod image
FROM alpine:3.13 as prod

COPY --from=build /go/src/github.com/hyperledger/external-builder/chaincode /app/chaincode

USER 1000

WORKDIR /app
CMD ./chaincode