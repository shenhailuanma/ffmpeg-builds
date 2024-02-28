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
if [ -f "cmake-$VERSION-ok" ]; then
  echo "cmake has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/cmake-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/cmake-$VERSION.tar.gz ./"

# unpack
tar -zxf "cmake-$VERSION.tar.gz"
checkStatus $? "unpack cmake-$VERSION.tar.gz"
cd cmake-$VERSION
checkStatus $? "cd cmake-$VERSION"


# prepare build
export OPENSSL_ROOT_DIR="$INSTALL_DIR"
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

touch "cmake-$VERSION-ok"
checkStatus $? "touch cmake-$VERSION-ok"