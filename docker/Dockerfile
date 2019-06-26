# syntax=docker/dockerfile:1.0-experimental

FROM buildpack-deps:19.04

ENV DEBIAN_FRONTEND=noninteractive

# SSH & Sudoers

RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                dumb-init \
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
        chown -R ${USER}: ${HOME}/.ssh; \
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
        curl -fsSL \
                "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" \
                -o /usr/local/bin/docker-compose; \
        chmod +x /usr/local/bin/docker-compose; \
        rm -rf /var/lib/apt/lists/*

# AWS CLI (& Python)

RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                python3-dev \
                python3-setuptools \
                python3-pip \
                groff \
                less \
        ; \
        pip3 install --upgrade pip; \
        pip3 install --upgrade awscli; \
        pip3 install --upgrade onelogin-aws-cli; \
        pip3 install requests==2.20.1; \
        rm -rf /var/lib/apt/lists/*

# Developer

USER ${USER}
WORKDIR ${HOME}

# Coder

EXPOSE 8443

ENV CODER_VER 1.1119-vsc1.33.1
ENV CODER_DIR code-server${CODER_VER}-linux-x64
ENV CODER_URL https://github.com/cdr/code-server/releases/download/${CODER_VER}/${CODER_DIR}.tar.gz

COPY ./etc/code-server-key.pem etc/code-server-key.pem
COPY ./etc/code-server.pem etc/code-server.pem

RUN set -ex; \
        sudo chown -R ${USER}: etc; \
        mkdir bin; \
        mkdir -p .local/share/code-server; \
        curl -fsSL ${CODER_URL} | tar -zx -C bin/ --strip=1 "${CODER_DIR}/code-server"

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "bin/code-server", "--cert", "etc/code-server.pem", "--cert-key", "etc/code-server-key.pem" ]

# Anyenv

RUN set -ex; \
        git clone https://github.com/anyenv/anyenv .anyenv; \
        ./.anyenv/bin/anyenv install --force-init

ENV PATH $HOME/.anyenv/bin:$PATH

RUN set -ex; \
        anyenv install goenv; \
        anyenv install nodenv; \
        anyenv install rbenv; \
        anyenv install pyenv; \
        anyenv init 2> $HOME/.bash_profile || true

RUN [ "/bin/bash", "-l", "-c", "\
        goenv install 1.12.6 \
    " ]

RUN rm $HOME/.bash_profile

# Vim & Dotfiles

RUN set -ex; \
        sudo apt-get update; \
        sudo apt-get install -y --no-install-recommends \
                vim \
                bash-completion \
                ack \
                jq \
                direnv \
        ; \
        sudo rm -rf /var/lib/apt/lists/*

RUN set -ex; \
        mkdir works; \
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

# END
