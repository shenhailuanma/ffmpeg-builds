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
if [ -f "openssl-$VERSION-ok" ]; then
  echo "openssl has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/openssl-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/openssl-$VERSION.tar.gz ./"

# unpack
tar -zxf "openssl-$VERSION.tar.gz"
checkStatus $? "unpack openssl-$VERSION.tar.gz"
cd openssl-$VERSION
checkStatus $? "cd openssl-$VERSION"

# prepare build
# use custom lib path, because for any reason on linux amd64 installs otherwise in lib64 instead
./config --prefix="$INSTALL_DIR" --openssldir="$INSTALL_DIR/openssl" --libdir="$INSTALL_DIR/lib" no-shared
checkStatus $? "configuration"

# build
make
checkStatus $? "make"

# install
## install without documentation
make install_sw
checkStatus $? "make install_sw"
make install_ssldirs
checkStatus $? "make install_ssldirs"

cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

touch "openssl-$VERSION-ok"
checkStatus $? "touch openssl-$VERSION-ok"