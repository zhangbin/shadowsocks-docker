FROM ubuntu:trusty

MAINTAINER jason <zhangbin.zj@gmail.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential autoconf libtool libssl-dev libpcre3-dev libudns-dev libev-dev asciidoc xmlto automake libc-ares-dev && \
    apt-get install -y wget && \
    apt-get install -y git && \
    git clone https://github.com/shadowsocks/simple-obfs.git && \
    cd simple-obfs && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure && make && make install && \
    apt-get install -y build-essential && \
    wget https://github.com/jedisct1/libsodium/releases/download/1.0.17/libsodium-1.0.17.tar.gz && \
    tar xf libsodium-1.0.17.tar.gz && cd libsodium-1.0.17 && \
    ./configure && make -j2 && make install && \
    ldconfig && \
    apt-get install -y --force-yes -m python-pip python-m2crypto && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

RUN pip install shadowsocks

ENV SS_SERVER_ADDR 0.0.0.0
ENV SS_SERVER_PORT 8388
ENV SS_PASSWORD password
ENV SS_METHOD chacha20
ENV SS_TIMEOUT 300

ADD start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE $SS_SERVER_PORT

CMD ["sh", "-c", "/start.sh"]
