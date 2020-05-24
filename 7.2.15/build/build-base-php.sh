#!/bin/sh

# See gearboxworks/gearbox-base for details.
test -f /build/include-me.sh && . /build/include-me.sh

c_ok "Started."

# ssh-keygen -A
BUILDDIR="/build"


if [ ! -d ${BUILDDIR} ]
then
	c_err "${BUILDDIR} doesn't exist."
	exit 1
fi


COMPILEDIR="${BUILDDIR}/compile"
OUTPUTDIR="${BUILDDIR}/output"
if [ ! -d ${COMPILEDIR} ]
then
	mkdir -p ${COMPILEDIR}
fi


BUILD_BINS="autoconf binutils bison build-base coreutils fakeroot file g++ gcc gnupg gpgme libarchive-tools make musl pacman pkgconf re2c rsync"
BUILD_LIBS="apache2-dev aspell-dev bzip2-dev curl-dev db-dev dpkg-dev enchant-dev freetds-dev freetype-dev gdbm-dev gettext-dev gmp-dev icu-dev imagemagick-dev imap-dev jpeg-dev krb5-dev libarchive libcurl libintl libressl2.7-libcrypto libc-dev libedit-dev libical-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev libressl-dev libsodium-dev libssh2-dev libwebp-dev libxml2-dev libxpm-dev libxslt-dev libzip-dev musl-dev net-snmp-dev openldap-dev pcre-dev postgresql-dev readline-dev recode-dev sqlite-dev tidyhtml-dev unixodbc-dev zlib-dev"
BUILD_DEPS="${BUILD_BINS} ${BUILD_LIBS}"

PERSIST_DEPS="bash sudo wget curl gnupg openssl shadow pcre ca-certificates tar xz imagemagick"

PHPBUILD="${COMPILEDIR}/php-${GEARBOX_CONTAINER_VERSION}"
PHPINSTALL="/usr/local"

# We are going to change the colour of the warnings instead of silencing them.
GCC_COLORS='error=01;31:warning=01;36:note=01;36:caret=01;32:locus=01:quote=01'; export GCC_COLORS
CFLAGS="-fstack-protector-strong -fpic -fpie -O2"; export CFLAGS
CPPFLAGS="$CFLAGS"; export CPPFLAGS
LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"; export LDFLAGS
EXTENSION_DIR=${PHPINSTALL}/lib/php/modules; export EXTENSION_DIR


c_ok "Adding packages."
apk update; checkExit
apk add --no-cache --virtual gearbox.persist $PERSIST_DEPS; checkExit
apk add --no-cache --virtual gearbox.build $BUILD_DEPS; checkExit


c_ok "Fetching tarballs."
cd ${COMPILEDIR}; checkExit
wget -nv -O "php-${GEARBOX_CONTAINER_VERSION}.tar.gz" -nv "$GEARBOX_CONTAINER_URL"; checkExit
tar zxf php-${GEARBOX_CONTAINER_VERSION}.tar.gz; checkExit


c_ok "Patching PHP ${GEARBOX_CONTAINER_VERSION}."
cd ${COMPILEDIR}; checkExit
patch -p0 < ${BUILDDIR}/install-pear.patch; checkExit
# patch -p0 < ${BUILDDIR}/libressl-2.7.patch; checkExit
patch -p0 < ${BUILDDIR}/allow-build-recode-and-imap-together.patch; checkExit
ln /usr/include/tidybuffio.h /usr/include/buffio.h


c_ok "Configure PHP ${GEARBOX_CONTAINER_VERSION}."
cd ${PHPBUILD}; checkExit
autoconf; checkExit
./configure --config-cache --cache-file=config.cache \
	--enable-fpm --with-fpm-user=${GEARBOX_USER} --with-fpm-group=${GEARBOX_GROUP} \
	--datadir=${PHPINSTALL}/share/php \
	--disable-gd-jis-conv \
	--disable-short-tags \
	--enable-bcmath=shared \
	--enable-calendar=shared \
	--enable-ctype=shared \
	--enable-dba=shared \
	--enable-dom=shared \
	--enable-exif=shared \
	--enable-fileinfo=shared \
	--enable-ftp=shared \
	--enable-intl=shared \
	--enable-json=shared \
	--enable-libxml \
	--enable-mbstring=shared \
	--enable-mysqlnd=shared \
	--enable-opcache=shared \
	--enable-pcntl=shared \
	--enable-pdo=shared \
	--enable-phar=shared \
	--enable-posix=shared \
	--enable-session=shared \
	--enable-shmop=shared \
	--enable-simplexml=shared \
	--enable-soap=shared \
	--enable-sockets=shared \
	--enable-sysvmsg=shared \
	--enable-sysvsem=shared \
	--enable-sysvshm=shared \
	--enable-tokenizer=shared \
	--enable-wddx=shared \
	--enable-xml=shared \
	--enable-xmlreader=shared \
	--enable-xmlwriter=shared \
	--enable-zip=shared \
	--libdir=${PHPINSTALL}/lib/php \
	--localstatedir=/var \
	--prefix=${PHPINSTALL} \
	--sysconfdir=${PHPINSTALL}/etc/php \
	--with-bz2=shared \
	--with-config-file-path=${PHPINSTALL}/etc/php \
	--with-config-file-scan-dir=${PHPINSTALL}/etc/php/conf.d \
	--with-curl=shared \
	--with-db4 \
	--with-dbmaker=shared \
	--with-enchant=shared \
	--with-freetype-dir=/usr \
	--with-gd=shared \
	--with-gdbm \
	--with-gettext=shared \
	--with-gmp=shared \
	--with-iconv=shared \
	--with-icu-dir=/usr \
	--with-imap-ssl \
	--with-imap=shared \
	--with-jpeg-dir=/usr \
	--with-kerberos \
	--with-layout=GNU \
	--with-ldap-sasl \
	--with-ldap=shared \
	--with-libedit \
	--with-libxml-dir=/usr \
	--with-libzip=/usr \
	--with-mysql-sock=/run/mysqld/mysqld.sock \
	--with-mysqli=shared,mysqlnd \
	--with-openssl=shared \
	--with-pcre-regex=/usr \
	--with-pdo-dblib=shared \
	--with-pdo-mysql=shared,mysqlnd \
	--with-pdo-odbc=shared,unixODBC,/usr \
	--with-pdo-pgsql=shared \
	--with-pdo-sqlite=shared,/usr \
	--with-pear=${PHPINSTALL}/share/php \
	--with-pgsql=shared \
	--with-pic \
	--with-png-dir=/usr \
	--with-pspell=shared \
	--with-recode=shared \
	--with-snmp=shared \
	--with-sodium=shared \
	--with-sqlite3=shared,/usr \
	--with-system-ciphers \
	--with-tidy=shared \
	--with-unixODBC=shared,/usr \
	--with-webp-dir=/usr \
	--with-xmlrpc=shared \
	--with-xpm-dir=/usr \
	--with-xsl=shared \
	--with-zlib \
	--with-zlib-dir=/usr \
	--without-readline; checkExit

#	--enable-gd-native-ttf

c_ok "Compile PHP ${GEARBOX_CONTAINER_VERSION}."
make; checkExit

c_ok "Install PHP ${GEARBOX_CONTAINER_VERSION}."
make install; checkExit
install -d -m755 ${PHPINSTALL}/etc/php/conf.d/; checkExit
# rmdir ${PHPINSTALL}/include/php; checkExit
mkdir -p /var/run/php; checkExit


c_ok "Adding Imagick extension, (3.4.3)."
cd ${PHPBUILD}/ext; checkExit
wget -nv http://pecl.php.net/get/imagick-3.4.3.tgz; checkExit
tar zxf imagick-3.4.3.tgz; checkExit
cd imagick-3.4.3; checkExit
phpize; checkExit
./configure; checkExit
make; checkExit
make install; checkExit


c_ok "Adding Xdebug extension, (2.6.0)."
cd ${PHPBUILD}/ext; checkExit
wget -nv https://xdebug.org/files/xdebug-2.6.0.tgz; checkExit
tar zxf xdebug-2.6.0.tgz; checkExit
cd xdebug-2.6.0; checkExit
phpize; checkExit
./configure; checkExit
make; checkExit
make install; checkExit


c_ok "Adding mcrypt extension, (1.0.1)."
cd ${PHPBUILD}/ext; checkExit
wget -nv http://pecl.php.net/get/mcrypt-1.0.1.tgz; checkExit
tar zxf mcrypt-1.0.1.tgz; checkExit
cd mcrypt-1.0.1; checkExit
phpize; checkExit
./configure; checkExit
make; checkExit
make install; checkExit


c_ok "Adding ssh2 extension, (1.1.2)."
cd ${PHPBUILD}/ext; checkExit
wget -nv http://pecl.php.net/get/ssh2-1.1.2.tgz; checkExit
tar zxf ssh2-1.1.2.tgz; checkExit
cd ssh2-1.1.2; checkExit
phpize; checkExit
./configure; checkExit
make; checkExit
make install; checkExit


c_ok "pecl update-channels."
# Fixup pecl errors.
# EG: "Warning: Invalid argument supplied for foreach() in ${PHPINSTALL}/share/pear/PEAR/Command.php
#     "Warning: Invalid argument supplied for foreach() in Command.php on line 249"
sed -i 's/^exec $PHP -C -n -q/exec $PHP -C -q/' ${PHPINSTALL}/bin/pecl; checkExit
pecl update-channels; checkExit


c_ok "Creating PHP tarball."
if [ ! -d "${OUTPUTDIR}" ]
then
	mkdir -p "${OUTPUTDIR}"; checkExit
fi
tar zcvf "${OUTPUTDIR}/php.tar.gz" /usr/local; checkExit


c_ok "Finished."
