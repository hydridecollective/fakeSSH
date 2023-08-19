#!/bin/bash
sh -c "rc-status; rc-service sshd start"

# keep container running
tail -f /dev/null

# trap ctrl-c and kill sshd process
trap "rc-service sshd stop" SIGINT

# trap kill sshd process
trap "rc-service sshd stop" SIGTERM