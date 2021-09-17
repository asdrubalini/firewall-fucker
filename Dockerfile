FROM ubuntu:21.04

RUN apt update -y && apt upgrade -y && apt install -y openvpn wget

RUN useradd --create-home user
USER user
WORKDIR /home/user
