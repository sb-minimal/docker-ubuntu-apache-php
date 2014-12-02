#!/bin/sh
ARGV="$@"
APACHE_CONFDIR=/etc/apache2
APACHE_ENVVARS="$APACHE_CONFDIR/envvars"
if test -f $APACHE_ENVVARS; then
  . $APACHE_ENVVARS
fi

if test "$APACHE_CONFDIR" != /etc/apache2 ; then
	APACHE_ARGUMENTS="-d $APACHE_CONFDIR $APACHE_ARGUMENTS"
fi
HTTPD=${APACHE_HTTPD:-/usr/sbin/apache2}

#ULIMIT_MAX_FILES="${APACHE_ULIMIT_MAX_FILES:-ulimit -n 8192}"
#if [ "x$ULIMIT_MAX_FILES" != "x" ] && [ `id -u` -eq 0 ] ; then
#    if ! $ULIMIT_MAX_FILES ; then
#        echo Setting ulimit failed. See README.Debian for more information. >&2
#    fi
#fi

rm -f ${APACHE_RUN_DIR:-/var/run/apache2}/*ssl_scache*
exec $HTTPD ${APACHE_ARGUMENTS} $ARGV

