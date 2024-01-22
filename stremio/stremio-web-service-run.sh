#!/bin/sh -e

http-server build/ -p 8080 -d false &
node server.js