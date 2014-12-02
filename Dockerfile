FROM ubuntu-debootstrap
MAINTAINER Stefan Baur

COPY scripts script

RUN chmod +x /scripts/*; mv /script/apache2.sh /; /scripts/setup; /scripts/cleanup -f bash sh dash cat tty mktemp rm grep groups ls du apache2  

ENTRYPOINT ["/apache2.sh"]

