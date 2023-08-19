
# fakeSSH:tunnel
# the tunnel container for fakeSSH, to isolate the honeypot from the internet
# Licenced under GPLv3, see LICENSE.md in root of repository for details

FROM alpine:latest

LABEL author="Hydride Collective"
LABEL maintainer="dani@hydride.dev"

#RUN apk add --update git ffmpeg curl wget gnupg ca-certificates bind-tools sqlite python3 tzdata xz libatomic bash zsh alpine-sdk sudo nano util-linux shadow openssh rsync
RUN apk add gnupg ca-certificates bind-tools bash zsh sudo nano util-linux shadow openssh rsync iptables sshpass
RUN echo "root:container" | chpasswd
RUN echo "container" | chsh -s /sbin/nologin

COPY ./resources/start.sh /start.sh
COPY ./resources/ssh.sh /ssh.sh
COPY ./resources/sshd_config /etc/ssh/sshd_config

# make container user, ensure it has its' own home directory
RUN adduser -D -h /home/container -s /bin/bash container \
    && echo "container:container" | chpasswd \
    && echo "container" | chsh -s /ssh.sh container \
    && mkdir -p /home/container \
    && chown -R container:container /home/container \
    && chmod +x /ssh.sh \
    && chmod 0700 /home/container \
    && mkdir -p /home/container/.ssh \
    && chmod 0700 /home/container/.ssh \
    && chown -R container:container /home/container/.ssh \
    && echo "" > /home/container/.ssh/authorized_keys \
    && chmod 0600 /home/container/.ssh/authorized_keys

RUN mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh \
    && passwd -u root \
    && apk add openrc openssh \
    && ssh-keygen -A \
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel

RUN rm -rf /etc/motd

CMD [ "/bin/bash", "/start.sh" ]