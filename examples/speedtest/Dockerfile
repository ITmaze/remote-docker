FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive
ARG server=31363
ENV env_var_name=$server

RUN apt-get update
RUN apt-get -y upgrade
ADD https://install.speedtest.net/app/cli/install.deb.sh install.deb.sh
RUN bash ./install.deb.sh
RUN apt-get -y install speedtest
RUN /usr/bin/speedtest --accept-license -s $env_var_name

ENTRYPOINT ["/usr/bin/speedtest"]
CMD ["--help"]
