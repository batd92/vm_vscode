#!/bin/sh
set -eu

if [ -z "${USER_ID}" ]; then
    echo "Error: USER_ID not set."
    exit 1
fi

export PS1='\w $ '

EXTENSIONS="${EXTENSIONS:-none}"
LAB_REPO="${LAB_REPO:-none}"

eval "$(fixuid -q)"

mkdir -p /home/coder/workspace
WORKSPACE_DIR="/home/coder/workspace"

mkdir -p /home/coder/.local/share/code-server/User

cat > /home/coder/.local/share/code-server/User/settings.json << EOF
{
    "locale": "ja",
    "workbench.startupEditor": "none",
    "workbench.activityBar.visible": false,
    "workbench.statusBar.visible": false,
    "workbench.tips.enabled": false,
    "window.menuBarVisibility": "toggle",
    "git.enabled": false,
    "extensions.ignoreRecommendations": true,
    "workbench.layoutControl.enabled": false,
    "keyboard.dispatch": "keyCode",
    "window.commandCenter": false,
    "workbench.settings.enableNaturalLanguageSearch": false,
    "workbench.settings.openDefaultSettings": false
}
EOF

cat > /home/coder/.local/share/code-server/User/keybindings.json << EOF
[
    { "key": "ctrl+,", "command": "-workbench.action.openSettings" },
    { "key": "ctrl+shift+p", "command": "-workbench.action.showCommands" },
    { "key": "ctrl+p", "command": "-workbench.action.quickOpen" },
    { "key": "f1", "command": "-workbench.action.showCommands" },
    { "key": "ctrl+shift+o", "command": "-editor.action.quickOutline" }
]
EOF

if [ "$(id -u)" -eq 0 ]; then
    echo "Running as root, changing ownership..."
    chown -R coder:coder /home/coder/workspace
    chown -R coder:coder /home/coder/.local
else
    echo "Not running as root, skipping chown"
fi

if [ "${DOCKER_USER-}" ]; then
    echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd > /dev/null
    sudo usermod --login "$DOCKER_USER" coder
    sudo groupmod -n "$DOCKER_USER" coder
    USER="$DOCKER_USER"
    sudo sed -i "/coder/d" /etc/sudoers.d/nopasswd
fi

if [ "${EXTENSIONS}" != "none" ]; then
    echo "Installing Extensions"
    for extension in $(echo ${EXTENSIONS} | tr "," "\n")
    do
        if [ "${extension}" != "" ]
        then
            dumb-init /usr/bin/code-server --install-extension "${extension}" /home/coder
        fi
    done
fi

if [ "${LAB_REPO}" != "none" ]; then
    cd workspace
    if [ ! -d "$(basename ${LAB_REPO} .git)" ]; then
        git clone ${LAB_REPO}
    else
        echo "Repo already exists, skipping clone."
    fi
    cd ..
fi

cd "$WORKSPACE_DIR"
echo "Using workspace: $WORKSPACE_DIR"

if [ "${HTTPS_ENABLED}" = "true" ]; then
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      --cert /home/coder/.certs/cert.pem \
      --cert-key /home/coder/.certs/key.pem \
      "$WORKSPACE_DIR"
else
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      "$WORKSPACE_DIR"
fi
