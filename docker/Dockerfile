# syntax=docker/dockerfile:1.0-experimental

FROM buildpack-deps:19.04

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                openssh-server \
                sudo \
                pwgen \
        ; \
        rm -rf /var/lib/apt/lists/*

ENV USER mine
ENV HOME /home/mine
ENV SHELL /bin/bash

RUN sed -ex; \
        mkdir /var/run/sshd; \
        groupadd -g 510 wheel; \
        useradd -d ${HOME} -m -s ${SHELL} -p $(pwgen -1sy 16) ${USER}; \
        gpasswd -a ${USER} wheel

COPY ./sudoers.d/wheel /etc/sudoers.d/wheel
COPY ./ssh/authorized_keys ${HOME}/.ssh/authorized_keys

RUN sed -ex; \
        chown -R mine: ${HOME}/.ssh; \
        chmod 700 ${HOME}/.ssh; \
        chmod 600 ${HOME}/.ssh/authorized_keys

# END
