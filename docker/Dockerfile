# syntax=docker/dockerfile:1.0-experimental

FROM buildpack-deps:22.04

ENV DEBIAN_FRONTEND noninteractive

# User & Sudoers

ARG USER=mine
ARG GROUP=${USER}

ARG UID=1000
ARG GID=1000

ARG HOME=/home/${USER}
ARG SHELL=/bin/bash

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        pwgen \
        sudo \
    ; \
    groupadd -g ${GID} ${GROUP}; \
    useradd -m -d ${HOME} -g ${GID} -s ${SHELL} ${USER}; \
    echo "${USER}:$(pwgen -1s 16)" | chpasswd; \
    rm -rf /var/lib/apt/lists/*

COPY ./sudoers.d/wheel /etc/sudoers.d/wheel

RUN set -ex; \
    groupadd -g 11 wheel; \
    gpasswd -a ${USER} wheel

# Timezone & Locale

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        tzdata \
        language-pack-en \
        language-pack-ja \
        locales \
    ; \
    rm -rf /var/lib/apt/lists/*

ENV TZ Etc/UTC

ARG LANG_WHICH=en
ARG LANG_WHERE=US
ARG ENCODING=UTF-8
ARG LANGUAGE=${LANG_WHICH}_${LANG_WHERE}.${ENCODING}

ENV LANG ${LANGUAGE}

# Docker

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        lsb-release \
    ; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        containerd.io \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY ./sudoers.d/docker /etc/sudoers.d/docker

RUN set -ex; \
    gpasswd -a ${USER} docker

# Docker Compose v2

RUN set -ex; \
    curl -fsSL "https://github.com/docker/compose/releases/download/v2.1.0/docker-compose-linux-$(uname -m)" -o /usr/libexec/docker/cli-plugins/docker-compose; \
    chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# Other apt-get
# - AWS CLI:    groff, less
# - Vim & Tool: vim, bash-completion, ack, jq
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        groff \
        less \
        vim \
        bash-completion \
        ack \
        jq \
    ; \
    rm -rf /var/lib/apt/lists/*

# Vim & Dotfiles

USER ${USER}
WORKDIR ${HOME}

RUN set -ex; \
    git clone https://github.com/mnkz51/dotfiles .dotfiles; \
    mv -i .bashrc .bashrc.org; \
    ln -s .dotfiles/.bashrc; \
    ln -s .dotfiles/.bash_profile; \
    ln -s .dotfiles/.dircolors; \
    ln -s .dotfiles/.gitconfig; \
    ln -s .dotfiles/.tool-versions; \
    mkdir -p .vim/backup .vim/swap; \
    cp -pr .dotfiles/.vim/autoload .vim/.; \
    ln -s .dotfiles/.vimrc; \
    mkdir works

# Asdf

RUN set -ex; \
    git clone https://github.com/asdf-vm/asdf.git .asdf; \
    cd ${HOME}/.asdf; \
    git checkout "$(git describe --abbrev=0 --tags)"; \
    cd ${HOME}

RUN [ "/bin/bash", "-l", "-c", " \
        . ${HOME}/.asdf/asdf.sh \
        && asdf plugin add awscli \
        && asdf install \
    " ]

# Vim

RUN set -ex; \
    echo '' | vim --not-a-term -c PlugInstall -c q -c q > /dev/null

# Entrypoint & CMD

CMD [ "/bin/bash", "-l" ]

# END
