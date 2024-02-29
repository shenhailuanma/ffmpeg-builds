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
if [ -f "libheif-$VERSION-ok" ]; then
  echo "libheif has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/libheif-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/libheif-$VERSION.tar.gz ./"

# unpack
tar -zxf "libheif-$VERSION.tar.gz"
checkStatus $? "unpack libheif-$VERSION.tar.gz"
cd libheif-$VERSION
checkStatus $? "cd libheif-$VERSION"

mkdir -p build
checkStatus $? "mkdir build"
cd build/
checkStatus $? "cd build/"

# prepare build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR -DENABLE_SHARED=NO -DENABLE_CLI=OFF --preset=release ..
checkStatus $? "cmake"

# # configure
# ./configure --prefix="$INSTALL_DIR"
# checkStatus $? "configure --prefix=$INSTALL_DIR"

# build
make
checkStatus $? "make"

# install
make install
checkStatus $? "make install"

cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

touch "libheif-$VERSION-ok"
checkStatus $? "touch libheif-$VERSION-ok"
