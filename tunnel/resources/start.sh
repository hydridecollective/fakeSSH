#!/bin/bash

# write SSH_HOST, SSH_USER, SSH_PASSWORD, SSH_PORT to /env
echo "SSH_HOST=$SSH_HOST" > /env
echo "SSH_USER=$SSH_USER" >> /env
echo "SSH_PASSWORD=$SSH_PASSWORD" >> /env
echo "SSH_PORT=$SSH_PORT" >> /env
echo "SSH_USE_PASSWORD=$SSH_USE_PASSWORD" >> /env

# check if ssh key exists at /data/auth. if one doesn't, generate an ED keypair
mkdir -p /data/auth

# generate a keypair if one doesn't exist
if [ ! -f /data/auth/key ]; then
    ssh-keygen -t ed25519 -f /data/auth/key -q -N "" # Generates an ED25519 pair at /data/auth/key with no passphrase
fi

chmod 600 /data/auth/key
# connect to ssh server
cp -R $SSH_KEY /tmp/key
chmod 600 /tmp/key

# if an authorized_keys file doesn't exist, copy the public key to it
if [ ! -f /data/auth/authorized_keys ]; then
    cp /data/auth/key.pub /data/auth/authorized_keys
fi

chmod +x /env

sh -c "/usr/sbin/sshd -De"