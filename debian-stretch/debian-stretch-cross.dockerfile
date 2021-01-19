FROM debian:stretch-slim

COPY ev3dev-archive-keyring.gpg /etc/apt/trusted.gpg.d/

# setup repositories and install required packages
COPY apt.sources.list.debian /etc/apt/sources.list
RUN dpkg --add-architecture armel && \
    dpkg --add-architecture armhf && \
    echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list \
    && apt-get update && \
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
        build-essential \
        debhelper \
        dh-systemd \
        openssh-client \
    && DEBIAN_FRONTEND=noninteractive apt-get -t stretch-backports install --yes --no-install-recommends \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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

COPY ["toolchain-*.cmake", "/home/compiler/"]