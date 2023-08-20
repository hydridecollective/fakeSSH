# fakeSSH:alpine
# the alpine container for fakeSSH, a docker-based ssh server for testing & honeypots
# Licenced under GPLv3, see LICENSE.md in root of repository for details

FROM alpine:latest

LABEL author="${USER} Collective"
LABEL maintainer="dani@${USER}.dev"

#RUN apk add --update git ffmpeg curl wget gnupg ca-certificates bind-tools sqlite python3 tzdata xz libatomic bash zsh alpine-sdk sudo nano util-linux shadow openssh rsync
RUN apk add gnupg ca-certificates bind-tools bash zsh sudo nano util-linux shadow openssh rsync python3 iptables
RUN echo "root:container" | chpasswd
RUN echo "container" | chsh -s /sbin/nologin

COPY ./resources/start.sh /start.sh
COPY ./resources/honeypotShell /honeypotShell
COPY ./resources/issue.net /etc/issue.net
COPY ./resources/sshd_config /etc/ssh/sshd_config
COPY ./resources/motd /etc/motd

ENV USER=sshUser
ENV PASSWORD=sshUser

RUN mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh \
    && passwd -u root \
    #&& echo "$PUBKEY" > /root/.ssh/authorized_keys \
    && apk add openrc openssh \
    && ssh-keygen -A \
    #&& echo -e "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel

# make ${USER}, ensure it has its' own home directory
RUN adduser -D -h /home/${USER} -s /bin/bash ${USER} \
    && echo "${USER}:${PASSWORD}" | chpasswd \
    && echo "container" | chsh -s /honeypotShell ${USER} \
    && mkdir -p /home/${USER}

RUN chown -R ${USER}:${USER} /home/${USER} \
    && chmod 0700 /home/${USER} \
    && mkdir -p /home/${USER}/.ssh \
    && chmod 0700 /home/${USER}/.ssh \
    && chown -R ${USER}:${USER} /home/${USER}/.ssh \
    && echo "" > /home/${USER}/.ssh/authorized_keys \
    && chmod 0600 /home/${USER}/.ssh/authorized_keys

RUN chmod +x /honeypotShell

CMD [ "/bin/bash", "/start.sh" ]