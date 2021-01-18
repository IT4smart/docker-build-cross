FROM debian:stretch-slim

COPY ev3dev-archive-keyring.gpg /etc/apt/trusted.gpg.d/

# setup repositories and install required packages
COPY apt.sources.list.debian /etc/apt/sources.lis
RUN dpkg --add-architecture armel && \
    dpkg --add-architecture armhf && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        bash-completion \
        ca-certificates \
        cmake \
        crossbuild-essential-armel \
        crossbuild-essential-armhf \
        gdb-multiarch \
        less \
        man-db \
        nano \
        pkg-config \
        qemu-user-static \
        sudo \
        tree \
        vim \
        wget \
        xz-utils \
        fakeroot \
        git \
        build-essential \
        debhelper \
        dh-systemd \
        openssh-client

# setup a new user
COPY compiler.sudoers /etc/sudoers.d/compiler
RUN chmod 0440 /etc/sudoers.d/compiler && \
    adduser --disabled-password --gecos \"\" compiler && \
    usermod -a -G sudo compiler \
    && mkdir /__w \
    && chown -R compiler:compiler /__w

USER compiler
WORKDIR /home/compiler
CMD ["/bin/bash", "--login"]

ADD ["toolchain-*.cmake", "/home/compiler/"]