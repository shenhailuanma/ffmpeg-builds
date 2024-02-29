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
if [ -f "libxml2-$VERSION-ok" ]; then
  echo "libxml2 has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/libxml2-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/libxml2-$VERSION.tar.gz ./"

# unpack
tar -zxf "libxml2-$VERSION.tar.gz"
checkStatus $? "unpack libxml2-$VERSION.tar.gz"
cd libxml2-$VERSION
checkStatus $? "cd libxml2-$VERSION"

echo "PATH:$PATH"

# check for pre-generated configure file
if [ -f "configure" ]; then
    echo "use existing configure file"
else
    ACLOCAL_PATH=$INSTALL_DIR/share/aclocal NOCONFIGURE=YES ./autogen.sh
    checkStatus $? "autogen.sh"
fi


# prepare build
./configure --prefix="$INSTALL_DIR" --enable-shared=no --without-python
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

touch "libxml2-$VERSION-ok"
checkStatus $? "touch libxml2-$VERSION-ok"