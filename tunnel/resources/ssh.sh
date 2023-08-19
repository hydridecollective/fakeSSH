#!/bin/sh

# no root allowed!
if [ "$(id -u)" = "0" ]; then
    exit 1
    logout
fi

bash -c 'sshpass -p container ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@ssh'