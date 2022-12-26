FROM mariadb:10.5.10

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV HOME /root

# Setting up initial packages
RUN apt update && apt install -y \
    wget \
    less \
    vim \
    git \
    curl \
    htop \
    unzip \
    inetutils-ping \
    inetutils-tools \
    net-tools \
    lsb-release \
    percona-toolkit \
    dnsutils \
    software-properties-common \
    ntp \
    rsyslog \
    curl \
    telnet \
    gnupg2 \
    tmux \
    netcat \
    pv \
    ncdu \
    sysstat \
    sysbench \
    openssh-server \
    openssh-client \
    && \
    apt-get clean
