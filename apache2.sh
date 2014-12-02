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
ULIMIT_MAX_FILES="${APACHE_ULIMIT_MAX_FILES:-ulimit -n 8192}"

if [ "x$ULIMIT_MAX_FILES" != "x" ] && [ `id -u` -eq 0 ] ; then
    if ! $ULIMIT_MAX_FILES ; then
        echo Setting ulimit failed. See README.Debian for more information. >&2
    fi
fi

ERROR=0

mkdir_chown () {
    local OWNER="$1"
    local DIR="$2"
    local STAT="$(LC_ALL=C stat -c %F:%U $DIR 2> /dev/null || true)"
    if [ "$STAT" = "" ] ; then
        local TMPNAME=$(mktemp -d $DIR.XXXXXXXXXX) || exit 1
        chmod 755 $TMPNAME || exit 1
        chown $OWNER $TMPNAME || exit 1
        if ! mv -T $TMPNAME $DIR 2> /dev/null; then
            rmdir $TMPNAME
            # check for race with other apachectl
            if [ "$(LC_ALL=C stat -c %F:%U $DIR 2>/dev/null)" != "directory:$OWNER" ]
            then
                echo Cannot create $DIR with owner $OWNER.
                echo Please fix manually. Aborting.
                exit 1
            fi
        fi
    elif [ "$STAT" != "directory:$OWNER" ] ; then
        echo $DIR already exists but is not a directory owned by $OWNER.
        echo Please fix manually. Aborting.
        exit 1
    fi
}

[ ! -d ${APACHE_RUN_DIR:-/var/run/apache2} ] && mkdir -p ${APACHE_RUN_DIR:-/var/run/apache2}
[ ! -d ${APACHE_LOCK_DIR:-/var/lock/apache2} ] && mkdir_chown ${APACHE_RUN_USER:-www-data} ${APACHE_LOCK_DIR:-/var/lock/apache2}


rm -f ${APACHE_RUN_DIR:-/var/run/apache2}/*ssl_scache*
exec $HTTPD ${APACHE_ARGUMENTS} -k $ARGV

