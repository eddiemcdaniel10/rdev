FROM ubuntu:bionic

RUN apt update
RUN apt install -y python3 python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install tensorflow-io-nightly
RUN adduser --disabled-password --gecos "" iodev
USER iodev
WORKDIR /home/iodev