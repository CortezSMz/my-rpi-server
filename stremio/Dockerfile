# Base image
FROM node:16-alpine AS base

WORKDIR /srv/
RUN apk add --no-cache git wget

#########################################################################

# Builder image
FROM base AS builder-web

WORKDIR /srv/
RUN git clone https://github.com/Stremio/stremio-web.git


WORKDIR /srv/stremio-web
RUN npm install
RUN npm run build

##########################################################################

# Get server - this can be combined with below - useful if you clone from git
FROM base AS builder-service

ARG VERSION=v4.20.5
ARG BUILD=desktop

WORKDIR /srv/stremio-service

RUN wget https://dl.strem.io/server/${VERSION}/${BUILD}/server.js

##########################################################################

# Main image
FROM node:16-alpine

WORKDIR /srv/stremio
COPY ./stremio-web-service-run.sh ./
RUN chmod +x *.sh
COPY --from=builder-web /srv/stremio-web/build ./build
COPY --from=builder-service /srv/stremio-service ./
RUN npm install -g http-server

ENV NO_CORS=0

# Expose default ports
EXPOSE 11470 8080

CMD ["./stremio-web-service-run.sh"]
