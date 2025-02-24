#!/bin/bash
export MSYS_NO_PATHCONV=1
USER_ID=$1

if [ -z "$USER_ID" ]; then
    echo "Error: Please provide a USER_ID."
    exit 1
fi

if docker service ls | grep -q "vscode-$USER_ID"; then
    echo "Service vscode-$USER_ID already exists."
    exit 0
fi

docker service create \
  --name vscode-$USER_ID \
  --replicas 1 \
  --env USER_ID="$USER_ID" \
  --env UID=1000 \
  --env GID=1000 \
  --env USER=1000 \
  --env APP_PORT=8443 \
  --env PASSWORD=htplus \
  --env EXTENSIONS=MS-CEINTL.vscode-language-pack-ja \
  --env HTTPS_ENABLED=false \
  --label "traefik.enable=true" \
  --label "traefik.http.routers.vscode-$USER_ID.rule=PathPrefix(\`/$USER_ID\`)" \
  --label "traefik.http.routers.vscode-$USER_ID.entrypoints=web" \
  --label "traefik.http.services.vscode-$USER_ID.loadbalancer.server.port=8443" \
  --label "traefik.http.middlewares.vscode-$USER_ID-stripprefix.stripPrefix.prefixes=/$USER_ID" \
  --label "traefik.http.routers.vscode-$USER_ID.middlewares=vscode-$USER_ID-stripprefix" \
  --mount type=volume,source=workspace-$USER_ID,target=/home/coder/workspace \
  --network my-stack_web \
  --limit-cpu 0.5 \
  --limit-memory 1g \
  batd92/htplus-vscode:v1

echo "Service created. Access at localhost/$USER_ID"