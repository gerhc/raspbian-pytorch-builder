FROM raspbian/stretch:latest
RUN apt update; apt upgrade -y; apt -y install vim parted unzip; apt clean

RUN mkdir /pytorch_install
WORKDIR /pytorch_install