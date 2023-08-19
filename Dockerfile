# fakeSSH:alpine
# the alpine container for fakeSSH, a docker-based ssh server for testing & honeypots
# Licenced under GPLv3, see LICENSE.md in root of repository for details

FROM alpine:latest

LABEL author="Hydride Collective"
LABEL maintainer="dani@hydride.dev"

ENV PUBKEY "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIi0KJNkFkZUUoSsiZod7XhJKDLWryo+D3SpOGxFPWOu"

#RUN apk add --update git ffmpeg curl wget gnupg ca-certificates bind-tools sqlite python3 tzdata xz libatomic bash zsh alpine-sdk sudo nano util-linux shadow openssh rsync
RUN apk add gnupg ca-certificates bind-tools bash zsh sudo nano util-linux shadow openssh rsync python3
RUN echo "root:container" | chpasswd
RUN echo "container" | chsh -s /honeypotShell

COPY ./resources/start.sh /start.sh
COPY ./resources/honeypotShell /honeypotShell
COPY ./resources/motd /etc/motd

RUN mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh \
    && passwd -u root \
    && echo "$PUBKEY" > /root/.ssh/authorized_keys \
    && apk add openrc openssh \
    && ssh-keygen -A \
    && echo -e "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel

CMD [ "/bin/bash", "/start.sh" ]