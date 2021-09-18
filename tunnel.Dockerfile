FROM ubuntu:21.04

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y wget iptables && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --create-home tunnel
# USER tunnel
WORKDIR /home/tunnel

RUN wget https://github.com/erebe/wstunnel/releases/download/v4.0/wstunnel-x64-linux
RUN mv wstunnel-x64-linux wstunnel && chmod +x wstunnel

ADD ./start-tunnel.sh .
RUN chmod +x ./start-tunnel.sh

CMD [ "./start-tunnel.sh" ]

