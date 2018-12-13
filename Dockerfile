FROM golang:1.11.1-alpine3.8 as builder
LABEL stage=intermediate

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go
ENV GO111MODULE=on

RUN set -x \
    && apk add --update --no-cache --virtual .build-deps \
    git \
    ca-certificates \
    gcc \
    libc-dev \
    libgcc \
    make \
    postgresql \
    && apk add --no-cache upx

# To create a rootless container
RUN adduser -D -g '' gkuser

WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN go fmt ./...\
    && make test \
    && make static \
    && apk del .build-deps \
    && echo "Build complete."

# Compress go binary
# https://linux.die.net/man/1/upx
# RUN upx -7 -qq output/gatekeeper && \
#     upx -t output/gatekeeper && \
#     mv output/gatekeeper /go/bin/gatekeeper

FROM scratch

WORKDIR /app

# COPY --from=builder /go/bin/gatekeeper .
COPY --from=builder /app/output/gatekeeper .
COPY --from=builder /app/configs ./configs
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs
COPY --from=builder /etc/passwd /etc/passwd

USER gkuser

ENTRYPOINT [ "./gatekeeper" ]
EXPOSE 8090