#!/bin/sh

# no root allowed!
if [ "$(id -u)" = "0" ]; then
    exit 1
    logout
fi

