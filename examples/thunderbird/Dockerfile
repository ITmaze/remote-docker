FROM debian:bullseye-slim

LABEL maintainer="onno@itmaze.com.au"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install thunderbird
RUN apt-get -y install libcanberra-gtk-module

RUN ln -s $(which thunderbird) /usr/local/bin/thunderbird

RUN useradd -ms /bin/bash docker
USER docker

ENTRYPOINT ["/usr/local/bin/thunderbird"]
