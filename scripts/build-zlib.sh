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
if [ -f "zlib-$VERSION-ok" ]; then
  echo "zlib has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/zlib-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/zlib-$VERSION.tar.gz ./"

# unpack
tar -zxf "zlib-$VERSION.tar.gz"
checkStatus $? "unpack zlib-$VERSION.tar.gz"
cd zlib-$VERSION
checkStatus $? "cd zlib-$VERSION"

# prepare build
./configure --prefix="$INSTALL_DIR" --static
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

touch "zlib-$VERSION-ok"
checkStatus $? "touch zlib-$VERSION-ok"