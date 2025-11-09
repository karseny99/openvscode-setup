#!/bin/bash

cp -Rn /home/initialWorkspace/.zshrc             /home/workspace/
cp -Rn /home/initialWorkspace/.openvscode-server /home/workspace/.openvscode-server
cp -Rn /home/initialWorkspace/.vscode /home/workspace/.vscode

if [ -n "$2" ]; then
    python3 /usr/local/lib/ask_password.py "$2"
fi

/home/.openvscode-server/bin/openvscode-server \
    --host 0.0.0.0 \
    --default-folder /home/workspace \
    --without-connection-token
