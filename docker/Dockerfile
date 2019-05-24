# syntax=docker/dockerfile:1.0-experimental

FROM buildpack-deps:19.04

# for SSH
EXPOSE 22

# for VNC
EXPOSE 5900

CMD ["/usr/sbin/sshd", "-D"]

ENV DEBIAN_FRONTEND=noninteractive

# SSH & Sudoers

RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                openssh-server \
                sudo \
                pwgen \
        ; \
        rm -rf /var/lib/apt/lists/*

ENV USER mine
ENV HOME /home/${USER}
ENV SHELL /bin/bash

RUN set -ex; \
        mkdir /var/run/sshd; \
        groupadd -g 510 wheel; \
        useradd -d ${HOME} -m -s ${SHELL} ${USER}; \
        echo "${USER}:$(pwgen -1s 16)" | chpasswd; \
        gpasswd -a ${USER} wheel

COPY ./sudoers.d/wheel /etc/sudoers.d/wheel
COPY ./ssh/authorized_keys ${HOME}/.ssh/authorized_keys

RUN set -ex; \
        chown -R mine: ${HOME}/.ssh; \
        chmod 700 ${HOME}/.ssh; \
        chmod 600 ${HOME}/.ssh/authorized_keys

# Timezone & Locale

ENV TZ Etc/UTC
ENV LANG_WHICH en
ENV LANG_WHERE US
ENV ENCODING UTF-8
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}

RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                tzdata \
                language-pack-en \
                language-pack-ja \
                locales \
        ; \
        echo "${TZ}" > /etc/timezone; \
        dpkg-reconfigure --frontend noninteractive tzdata; \
        locale-gen ${LANGUAGE}; \
        dpkg-reconfigure --frontend noninteractive locales; \
        rm -rf /var/lib/apt/lists/*

# X & VNC

RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                xvfb \
                fluxbox \
                x11vnc \
        ; \
        rm -rf /var/lib/apt/lists/*

# Docker & Compose

RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                software-properties-common \
        ; \
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -; \
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable edge test"; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                docker-ce \
                docker-ce-cli \
                containerd.io \
        ; \
        curl -L \
                "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" \
                -o /usr/local/bin/docker-compose; \
        chmod +x /usr/local/bin/docker-compose; \
        rm -rf /var/lib/apt/lists/*

# Development

USER ${USER}
WORKDIR ${HOME}

RUN set -ex; \
        sudo apt-get update; \
        sudo apt-get install -y --no-install-recommends \
                vim \
                bash-completion \
                ack \
                jq \
        ; \
        sudo rm -rf /var/lib/apt/lists/*

RUN set -ex; \
        git clone https://github.com/mnkz51/dotfiles .dotfiles; \
        mv -i .bashrc .bashrc.disco-org; \
        ln -s .dotfiles/.bashrc; \
        ln -s .dotfiles/.bash_profile; \
        ln -s .dotfiles/.dircolors; \
        ln -s .dotfiles/.gitconfig; \
        mkdir -p .vim/backup .vim/swap; \
        cp -pr .dotfiles/.vim/autoload .vim/.; \
        ln -s .dotfiles/.vimrc; \
        echo "" | vim --not-a-term -c PlugInstall -c q -c q > /dev/null

RUN set -ex; \
        git clone https://github.com/anyenv/anyenv .anyenv; \
        ./.anyenv/bin/anyenv install --force-init

RUN [ "/bin/bash", "-l", "-c", " \
        anyenv install goenv \
        && anyenv install nodenv \
        && anyenv install rbenv \
    " ]

USER root
WORKDIR /

# END
