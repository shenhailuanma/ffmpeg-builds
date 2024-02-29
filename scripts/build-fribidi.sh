#!/bin/sh

# handle arguments
echo "Arguments: $@"
SCRIPT_DIR=$1
SOURCE_DIR=$2
BUILD_DIR=$3
INSTALL_DIR=$4
VERSION=$5

# load functions
. $SCRIPT_DIR/functions.sh

# version
echo "version: $VERSION"

# start in working directory
cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

# check whether it has been completed
if [ -f "fribidi-$VERSION-ok" ]; then
  echo "fribidi has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/fribidi-$VERSION.tar.xz ./
checkStatus $? "cp -r $SOURCE_DIR/fribidi-$VERSION.tar.xz ./"

# unpack
tar -zxf "fribidi-$VERSION.tar.xz"
checkStatus $? "unpack fribidi-$VERSION.tar.xz"
cd fribidi-$VERSION
checkStatus $? "cd fribidi-$VERSION"


# prepare build
./configure --prefix="$INSTALL_DIR" --enable-shared=no --enable-static=yes
checkStatus $? "configuration"

# build
make
checkStatus $? "make"

# install
make install
checkStatus $? "make install"

# 
cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

touch "fribidi-$VERSION-ok"
checkStatus $? "touch fribidi-$VERSION-ok"