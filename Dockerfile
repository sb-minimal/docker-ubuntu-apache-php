FROM ubuntu-debootstrap
MAINTAINER Stefan Baur

COPY scripts scripts

RUN chmod +x /scripts/*; mv /scripts/apache2.sh /; /scripts/setup; /scripts/cleanup -f bash sh dash cat tty mktemp rm grep groups ls du apache2  

ENTRYPOINT ["/apache2.sh"]
EXPOSE ["80"]

