FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install git

RUN ln -s $(which git) /usr/local/bin/git

RUN useradd -ms /bin/bash docker
USER docker

ENTRYPOINT ["/usr/local/bin/git"]
CMD ["--help"]
