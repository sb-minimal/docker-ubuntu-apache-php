FROM ubuntu
MAINTAINER Stefan Baur

COPY scripts scripts

RUN chmod +x /scripts/*; mv /scripts/apache2.sh /; sleep 1; /scripts/setup; /scripts/cleanup -f bash sh dash cat tty mktemp rm grep groups ls du apache2 ssmtp sendmail php php7 php7.0 php* animate composite conjure convert display gm identify import mogrify montage paxctl gs

ENTRYPOINT ["/apache2.sh","-DFOREGROUND"]
EXPOSE 80

