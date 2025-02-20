#!/bin/sh
set -eu

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

docker stack deploy -c docker-compose.yml vscode_stack
