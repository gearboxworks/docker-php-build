#!/bin/sh

# See gearboxworks/gearbox-base for details.
test -f /build/build-base.sh && /bin/sh /build/build-base.sh
test -f /build/include-me.sh && . /build/include-me.sh

c_ok "Started."

BUILDDIR="/build"


if [ "$BUILD_TYPE" != "" ]
then
	c_ok "Maintaining build packages for build type \"$BUILD_TYPE\"."
	exit 0
fi


c_ok "Setting permissions."
find /usr/local/bin /usr/local/sbin -type f | xargs chmod a+x


c_ok "Removing build packages for runtime."
apk del gearbox.build; checkExit


c_ok "Adding packages required by PHP ${GEARBOX_CONTAINER_VERSION}."
RUNTIME_DEPS="$(scanelf --needed --nobanner --format '%n#p' --recursive /usr | tr ',' '\n' | sort -u | awk '/libmysqlclient.so.16/{next} system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }')"
c_ok "Installing $(echo "${RUNTIME_DEPS}" | grep -c 'so:') packages."
apk add --no-cache --virtual gearbox.runtime ${RUNTIME_DEPS}; checkExit
apk add libedit aspell-libs libxpm libzip icu-libs; checkExit


c_ok "Cleaning up."
rm -rf ${BUILDDIR}/compile; checkExit
unset BUILD_DEPS PERSIST_DEPS RUNTIME_DEPS CPPFLAGS LDFLAGS CFLAGS EXTENSION_DIR
# find . -type f -perm +0111 -exec strip --strip-all '{}'


c_ok "Finished."
