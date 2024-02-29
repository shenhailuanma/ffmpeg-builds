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
if [ -f "pkg-config-$VERSION-ok" ]; then
  echo "pkg-config has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/pkg-config-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/pkg-config-$VERSION.tar.gz ./"

# unpack
tar -zxf "pkg-config-$VERSION.tar.gz"
checkStatus $? "unpack pkg-config-$VERSION.tar.gz"
cd pkg-config-$VERSION
checkStatus $? "cd pkg-config-$VERSION"

# prepare build
./configure --prefix="$INSTALL_DIR" --with-pc-path="$INSTALL_DIR/lib/pkgconfig" --with-internal-glib
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

touch "pkg-config-$VERSION-ok"
checkStatus $? "touch pkg-config-$VERSION-ok"