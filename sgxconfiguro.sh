#!/bin/sh

# Latest version for SGX SDKs available at
# http://www.github.com/prabindh/sgxrus

# This script enables "out-of-tree" build of frameworks 
# that directly use GLES2/GLES1/PVR2D/WSEGL, enabling
# pkg-config for dependency checks. This primarily 
# includes Qt, and other frameworks that use a Qt backend.

# For including sgx build in autoconfig, use sgxconfiguro.in

# Pre-req:
# SGX libraries should be "installed" in the rootfs and demos functional per below guide:
# http://processors.wiki.ti.com/index.php/Graphics_SDK_Quick_installation_and_user_guide

# Usage:
# sgxconfiguro.sh <GraphicsSDK dir> <rootfs dir> <OGLES1 or OGLES2>

NUMARGS=3
LOOKFOR=opt/gfxsdkdemos/gfxinstallinfo.txt
ERRSTR=[error]
OKSTR=[ok]
INFOSTR=[info]

if test "$#" -lt $NUMARGS ; then
 echo "Usage: ./sgxrus_install.sh <GraphicsSDK dir> <rootfs dir> <OGLES1 or OGLES2>"
 exit 1
fi

if test -e "$1/include/$3" ; then
  echo "$3 found in-$1, $OKSTR"
else
  echo "$3 not found in $1...$ERRSTR"
  exit 1
fi

if test -e "$2/$LOOKFOR" ; then
  echo "Valid rootfs-$2, $OKSTR"
else
  echo "$LOOKFOR not found in rootfs (Graphics SDK not installed ?) ...$ERRSTR"
  exit 1
fi

#copy headers
mkdir -p $2/usr/include/sgx
cp -rf $1/include/* $2/usr/include/sgx/
echo "copied headers to <rootfsdir>/usr/include/sgx $OKSTR"

#install pc file
mkdir -p $2/usr/lib/pkgconfig
if test "$3" = "OGLES2"; then
   cp -f ./pkgconfig/sgx-null-gles2.pc $2/usr/lib/pkgconfig
else
   cp -f ./pkgconfig/sgx-null-gles1.pc $2/usr/lib/pkgconfig
fi

echo "installed pkgconfig information to <rootfsdir>/usr/lib/pkgconfig $OKSTR"
echo "Use sgxconfiguro.in for autoconfig $INFOSTR"
