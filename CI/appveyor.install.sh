#!/bin/sh

echo "Running appveyor.install.sh shell script..."

# Source/setup some variables (including PATH):
. $(/usr/bin/cygpath --unix ${APPVEYOR_BUILD_FOLDER}/CI/appveyor.set-build-info.sh)

if [ ${BUILD_BITNESS} != "32" ] && [ ${BUILD_BITNESS} != "64" ] ; then
    echo "Requires environmental variable BUILD_BITNESS to exist and be set to \"32\" or \"64\" to specify bitness of target to be built."
    exit 1
fi

# Options:
# --Sy = Sync, refresh as well as installing the specified packages
# --noconfirm = do not ask for user intervention
# --noprogressbar = do not show progress bars as they are not useful in scripts

echo "Updating MSYS2 packages..."

# Uncomment this to use user luarocks
# ROCKOPTARGS=--local
if [ "${BUILD_BITNESS}" = "32" ] ; then
    BUILDCOMPONENT="i686"
else
    BUILDCOMPONENT="x86_64"
fi

ROCKCOMMAND=${MINGW_INTERNAL_BASE_DIR}/bin/luarocks

/usr/bin/pacman -S --needed --noconfirm \
    base-devel \
    coreutils \
    msys2-runtime \
    git \
    mercurial \
    cvs \
    wget \
    ruby \
    zip \
    p7zip \
    python2 \
    rsync \
    mingw-w64-${BUILDCOMPONENT}-toolchain \
    mingw-w64-${BUILDCOMPONENT}-qt5 \
    mingw-w64-${BUILDCOMPONENT}-libzip \
    mingw-w64-${BUILDCOMPONENT}-pugixml \
    mingw-w64-${BUILDCOMPONENT}-lua51 \
    mingw-w64-${BUILDCOMPONENT}-lua51-lpeg \
    mingw-w64-${BUILDCOMPONENT}-lua51-lsqlite3 \
    mingw-w64-${BUILDCOMPONENT}-lua51-luarocks \
    mingw-w64-${BUILDCOMPONENT}-hunspell \
    mingw-w64-${BUILDCOMPONENT}-zlib \
    mingw-w64-${BUILDCOMPONENT}-boost \
    mingw-w64-${BUILDCOMPONENT}-yajl \
    mingw-w64-${BUILDCOMPONENT}-SDL2

# This was to fix https://github.com/msys2/MINGW-packages/issues/5928 but that
# has now been done by https://github.com/msys2/MINGW-packages/pull/6580:
#if [ ${BUILD_BITNESS} = "32" ] ; then
#    # The site_config.lua file for the MINGW32 case has so many wrong values
#    # it prevents luarocks from working - however it can be repaired by some
#    # editing:
#    cp /mingw32/share/lua/5.1/luarocks/site_config.lua /mingw32/share/lua/5.1/luarocks/site_config.lua.orig
#    /usr/bin/sed "s|/mingw32|c:/msys64/mingw32|g" /mingw32/share/lua/5.1/luarocks/site_config.lua.orig \
#      | /usr/bin/sed "s|/lib/luarocks/rocks|/lib/luarocks/rocks-5.1|" > /mingw32/share/lua/5.1/luarocks/site_config.lua
#
#    # Also need to change one thing in the config-5.1.lua file:
#    cp /mingw32/etc/luarocks/config-5.1.lua /mingw32/etc/luarocks/config-5.1.lua.orig
#    /usr/bin/sed "s|/mingw32|c:/msys64/mingw32|g" /mingw32/etc/luarocks/config-5.1.lua.orig > /mingw32/etc/luarocks/config-5.1.lua
#fi

echo ""
echo "    .... MSYS2 Package installation completed."
echo ""
echo " Lua configuration files are: (system): $(${ROCKCOMMAND} config --system-config)"
echo "                            and (user): $(${ROCKCOMMAND} config --user-config)"
echo ""
echo "   The system one contains:"
/usr/bin/cat $(${ROCKCOMMAND} config --system-config)

echo ""
echo "  Installing needed luarocks..."
echo ""
echo "    luafilesystem"
${ROCKCOMMAND} ${ROCKOPTARGS} install luafilesystem
echo ""
echo "    lua-yajl"
${ROCKCOMMAND} ${ROCKOPTARGS} install lua-yajl
echo ""
echo "    luautf8"
${ROCKCOMMAND} ${ROCKOPTARGS} install luautf8
echo ""
echo "    luazip"
${ROCKCOMMAND} ${ROCKOPTARGS} install luazip
echo ""
echo "    lrexlib-pcre"
${ROCKCOMMAND} ${ROCKOPTARGS} install lrexlib-pcre
echo ""
echo "    luasql-sqlite3"
${ROCKCOMMAND} ${ROCKOPTARGS} install luasql-sqlite3
echo ""
echo "    ... luarocks installation done"
echo ""
echo "  ... appveyor.install.sh shell script finished!"
echo ""
