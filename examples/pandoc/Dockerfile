FROM debian:bullseye-slim

LABEL maintainer="onno@itmaze.com.au"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install pandoc
RUN apt-get -y install texlive-latex-base
RUN apt-get -y install texlive-latex-recommended

ADD https://github.com/jgm/pandoc/releases/download/3.1.3/pandoc-3.1.3-1-amd64.deb /tmp/pandoc.deb
RUN apt-get -y install /tmp/pandoc.deb

RUN ln -s $(which pandoc) /usr/local/bin/pandoc

RUN useradd -ms /bin/bash docker
USER docker

ENTRYPOINT ["/usr/local/bin/pandoc"]
CMD ["--help"]
