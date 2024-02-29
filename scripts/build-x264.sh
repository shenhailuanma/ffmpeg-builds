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
if [ -f "x264-$VERSION-ok" ]; then
  echo "x264 has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/x264-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/x264-$VERSION.tar.gz ./"

# unpack
tar -zxf "x264-$VERSION.tar.gz"
checkStatus $? "unpack x264-$VERSION.tar.gz"
cd x264-$VERSION
checkStatus $? "cd x264-$VERSION"


# prepare build
./configure --prefix="$INSTALL_DIR" --enable-static --disable-cli
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

touch "x264-$VERSION-ok"
checkStatus $? "touch x264-$VERSION-ok"