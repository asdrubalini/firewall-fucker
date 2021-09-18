FROM ubuntu:21.04

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y wget iptables && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --create-home tunnel
# USER tunnel
WORKDIR /home/tunnel

RUN wget https://github.com/wangyu-/udp2raw-tunnel/releases/download/20200818.0/udp2raw_binaries.tar.gz && \
    tar xvf *.tar.gz && \
    rm *.tar.gz

ADD ./start-tunnel.sh .
RUN chmod +x ./start-tunnel.sh

CMD [ "./start-tunnel.sh" ]

