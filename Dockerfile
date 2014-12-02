FROM ubuntu-debootstrap
MAINTAINER Stefan Baur

ADD scripts scripts

RUN /scripts/setup; /scripts/cleanup -f bash sh dash cat tty mktemp rm grep groups ls du apache2 apache2ctl

