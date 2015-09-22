#!/bin/bash
set -e

SSH_DIR="/root/.ssh"

# Set ownership
chmod 600 ${SSH_DIR}/id_rsa ${SSH_DIR}/id_rsa.pub
chmod 700 ${SSH_DIR}
chown -R root:root ${SSH_DIR}

# Add key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ${SSH_DIR}/id_rsa
