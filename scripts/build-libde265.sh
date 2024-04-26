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
if [ -f "libde265-$VERSION-ok" ]; then
  echo "libde265 has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/libde265-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/libde265-$VERSION.tar.gz ./"

# unpack
tar -zxf "libde265-$VERSION.tar.gz"
checkStatus $? "unpack libde265-$VERSION.tar.gz"
cd libde265-$VERSION
checkStatus $? "cd libde265-$VERSION"


# check for pre-generated configure file
if [ -f "configure" ]; then
    echo "use existing configure file"
else
    ACLOCAL_PATH=$INSTALL_DIR/share/aclocal NOCONFIGURE=YES ./autogen.sh
    checkStatus $? "autogen.sh"
fi

# prepare build
./configure --prefix="$INSTALL_DIR" --disable-dec265 --disable-sherlock265
checkStatus $? "configure --prefix=$INSTALL_DIR"

# build
make
checkStatus $? "make"

# install
make install
checkStatus $? "make install"

cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

touch "libde265-$VERSION-ok"
checkStatus $? "touch libde265-$VERSION-ok"
