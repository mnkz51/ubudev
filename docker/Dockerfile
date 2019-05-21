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

RUN set -ex; \
        mkdir /var/run/sshd; \
        groupadd -g 510 wheel; \
        useradd -d ${HOME} -m -s ${SHELL} -p "$(pwgen -1s 16)" ${USER}; \
        gpasswd -a ${USER} wheel

COPY ./sudoers.d/wheel /etc/sudoers.d/wheel
COPY ./ssh/authorized_keys ${HOME}/.ssh/authorized_keys

RUN set -ex; \
        chown -R mine: ${HOME}/.ssh; \
        chmod 700 ${HOME}/.ssh; \
        chmod 600 ${HOME}/.ssh/authorized_keys

USER ${USER}
WORKDIR ${HOME}

RUN set -ex; \
        sudo apt-get update; \
        sudo apt-get install -y --no-install-recommends \
                vim \
        ; \
        sudo rm -rf /var/lib/apt/lists/*

RUN set -ex; \
        git clone https://github.com/mnkz51/dotfiles .dotfiles; \
        mv -i .bashrc .bashrc.disco-org; \
        ln -s .dotfiles/.bashrc; \
        ln -s .dotfiles/.bash_profile; \
        ln -s .dotfiles/.dircolors; \
        mkdir -p .vim/backup .vim/swap; \
        cp -pr .dotfiles/.vim/autoload .vim/.; \
        ln -s .dotfiles/.vimrc; \
        echo "" | vim --not-a-term -c PlugInstall -c q -c q > /dev/null

RUN set -ex; \
        git clone https://github.com/anyenv/anyenv .anyenv; \
        ./.anyenv/bin/anyenv install --force-init

USER root

# END
