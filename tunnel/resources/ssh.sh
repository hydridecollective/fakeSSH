#!/bin/bash

source /env

# no root allowed!
if [ "$(id -u)" = "0" ]; then
    exit 1
    logout
fi

# host/username/pwd/port for ssh is defined by compose. if not set, use default (example host is ssh)
if [ -z "$SSH_HOST" ]; then
    SSH_HOST=ssh
fi
if [ -z "$SSH_USER" ]; then
    SSH_USER=root
fi
if [ -z "$SSH_PASSWORD" ]; then
    SSH_PASSWORD=ssh
fi
if [ -z "$SSH_PORT" ]; then
    SSH_PORT=22
fi
if [ -z "$SSH_KEY" ]; then
    SSH_KEY=/data/auth/key
fi

# if $SSH_USE_PASSWORD is set to true, use password auth. otherwise, use key auth
if [ "$SSH_USE_PASSWORD" = "true" ]; then
    bash -c "sshpass -p $SSH_PASSWORD ssh -o LogLevel=error -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $SSH_PORT $SSH_USER@$SSH_HOST"
else
    # connect to ssh server
    cp -R $SSH_KEY /tmp/key
    chmod 600 /tmp/key
    ssh -o StrictHostKeyChecking=no -oLogLevel=error -p $SSH_PORT -i /tmp/key $SSH_USER@$SSH_HOST
fi