#!/bin/sh

# handle arguments
echo "Arguments: $@"
SCRIPT_DIR=$1
SOURCE_DIR=$2
BUILD_DIR=$3
INSTALL_DIR=$4
VERSION=$5
FFMPEG_LIB_FLAGS=$6

# load functions
. $SCRIPT_DIR/functions.sh

# version
echo "version: $VERSION"
echo "FFMPEG_LIB_FLAGS: $FFMPEG_LIB_FLAGS"

# start in working directory
cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

# check whether it has been completed
if [ -f "ffmpeg-$VERSION-ok" ]; then
  echo "ffmpeg has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/ffmpeg-$VERSION.tar.xz ./
checkStatus $? "cp -r $SOURCE_DIR/ffmpeg-$VERSION.tar.xz ./"

# unpack
tar -zxf "ffmpeg-$VERSION.tar.xz"
checkStatus $? "unpack ffmpeg-$VERSION.tar.xz"
cd ffmpeg-$VERSION
checkStatus $? "cd ffmpeg-$VERSION"

# prepare build
EXTRA_VERSION="https://www.martin-riedl.de"
FF_FLAGS="-L${INSTALL_DIR}/lib -I${INSTALL_DIR}/include"
export LDFLAGS="$FF_FLAGS"
export CFLAGS="$FF_FLAGS"
# --pkg-config-flags="--static" is required to respect the Libs.private flags of the *.pc files
./configure --prefix="$OUT_DIR" --pkg-config-flags="--static" --extra-version="$EXTRA_VERSION" \
    --enable-gray --enable-libxml2 --enable-gpl $FFMPEG_LIB_FLAGS
checkStatus $? "configuration"

# start build
make
checkStatus $? "make"

# install ffmpeg
make install
checkStatus $? "make install"
