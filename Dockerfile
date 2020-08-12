FROM golang:latest as gobuilder

# Build a statically linked binary
RUN CGO_ENABLED=0 GOOS=linux go get -ldflags="-extldflags=-static" github.com/proctorlabs/confluence-cli

FROM asciidoctor/docker-asciidoctor:latest

RUN export PANDOC_VERSION=2.10.1 && \
    export DIR=pandoc-${PANDOC_VERSION} && \
    export FILE=pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz && \
    export URL=https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/$FILE && \
    curl -fsSL ${URL} > ${FILE} && tar xzvf ${FILE} && cp ${DIR}/bin/* /usr/local/bin && rm -rf ${DIR}

COPY --from=gobuilder /go/bin/confluence-cli /usr/local/bin
