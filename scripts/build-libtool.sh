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
if [ -f "libtool-$VERSION-ok" ]; then
  echo "libtool has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/libtool-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/libtool-$VERSION.tar.gz ./"

# unpack
tar -zxf "libtool-$VERSION.tar.gz"
checkStatus $? "unpack libtool-$VERSION.tar.gz"
cd libtool-$VERSION
checkStatus $? "cd libtool-$VERSION"


# prepare build
./configure --prefix="$INSTALL_DIR"
checkStatus $? "configure --prefix=$INSTALL_DIR"

# build
make
checkStatus $? "make"

# install
make install
checkStatus $? "make install"

#
cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

touch "libtool-$VERSION-ok"
checkStatus $? "touch libtool-$VERSION-ok"