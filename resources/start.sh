#!/bin/bash

# if $USER doesn't exist, fail
if [ -z "$USER" ]; then
    echo "USER environment variable not set. Exiting."
    exit 1
fi

# check if ssh key exists at /data/auth. if one doesn't, generate an ED keypair
mkdir -p /data/auth

# generate a keypair if one doesn't exist
if [ ! -f /data/auth/key ]; then
    ssh-keygen -t ed25519 -f /data/auth/key -q -N "" # Generates an ED25519 pair at /data/auth/key with no passphrase
fi

# if an authorized_keys file doesn't exist, copy the public key to it
if [ ! -f /data/auth/authorized_keys ]; then
    cp /data/auth/key.pub /data/auth/authorized_keys
fi

# if $SSH_USE_PASSWORD is set, enable password authentication and empty password
if [ "$SSH_USE_PASSWORD" = "true" ]; then
    echo "Enabling password authentication"
    echo >> /etc/ssh/sshd_config
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config
else # otherwise, disable password authentication
    echo "Disabling password authentication"
    echo >> /etc/ssh/sshd_config
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
fi

chmod 600 /data/auth/key

# copy authorized_keys to $USER's home directory
mkdir -p /home/$USER/.ssh
cp /data/auth/authorized_keys /home/$USER/.ssh/authorized_keys

# set proper permissions
chown -R $USER:$USER /home/$USER/.ssh
chmod -R 700 /home/$USER/.ssh
chmod 600 /home/$USER/.ssh/authorized_keys

sh -c "/usr/sbin/sshd -De"