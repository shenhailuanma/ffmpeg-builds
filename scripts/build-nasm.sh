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

echo "version: $VERSION"

# start in working directory
cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

# check whether it has been completed
if [ -f "nasm-$VERSION-ok" ]; then
  echo "nasm has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/nasm-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/nasm-$VERSION.tar.gz ./"

# unpack
tar -zxf "nasm-$VERSION.tar.gz"
checkStatus $? "unpack nasm-$VERSION.tar.gz"
cd nasm-$VERSION
checkStatus $? "cd nasm-$VERSION"

# prepare build
if [ -f "configure" ]; then
    echo "configure file found; continue"
else
    echo "run autogen first"
    ./autogen.sh
    checkStatus "autogen"
fi
./configure --prefix="$INSTALL_DIR"
checkStatus $? "configure --prefix=$INSTALL_DIR"

# build
make
checkStatus $? "make"

# install
make install
checkStatus $? "make install"

cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

touch "nasm-$VERSION-ok"
checkStatus $? "touch nasm-$VERSION-ok"