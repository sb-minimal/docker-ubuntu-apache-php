FROM ubuntu-debootstrap
MAINTAINER Stefan Baur

COPY scripts apache2.sh /

RUN chmod +x /apache2.sh /scripts/*; /scripts/setup; /scripts/cleanup -f bash sh dash cat tty mktemp rm grep groups ls du apache2  

ENTRYPOINT["/apache2.sh"]

