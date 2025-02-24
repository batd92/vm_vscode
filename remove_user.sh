#!/bin/bash
USER_ID=$1

if [ -z "$USER_ID" ]; then
    echo "Error: Please provide a USER_ID."
    exit 1
fi

docker service rm vscode-$USER_ID
echo "Service vscode-$USER_ID removed."