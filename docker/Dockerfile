FROM raspbian/stretch:latest
RUN apt update; apt upgrade -y; apt -y install git parted unzip; apt clean

RUN mkdir /pytorch_install
WORKDIR /pytorch_install