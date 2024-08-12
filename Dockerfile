FROM debian:trixie-slim

MAINTAINER aitor3ml <aitor3ml@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY :0

ENV LANG es_ES.UTF-8 
ENV LANGUAGE es_ES
ENV LC_ALL es_ES.UTF-8

RUN apt update && apt-get install -y locales \
 && sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen && locale-gen \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=es_ES.UTF-8
 && apt-get update \
 && apt-get -y install gnucash python3-gst-1.0 \
 && apt-get -y autoremove \
 && apt-get clean

CMD [ "gnucash", "--logto", "stderr" ]
