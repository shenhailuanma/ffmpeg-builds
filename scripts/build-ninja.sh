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
if [ -f "ninja-$VERSION-ok" ]; then
  echo "ninja has been completed"
  exit 0
fi

# copy source file
cp -r $SOURCE_DIR/ninja-$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/ninja-$VERSION.tar.gz ./"

# unpack
tar -zxf "ninja-$VERSION.tar.gz"
checkStatus $? "unpack ninja-$VERSION.tar.gz"
cd ninja-$VERSION
checkStatus $? "cd ninja-$VERSION"

# prepare build
mkdir -p ninja_build
checkStatus $? "create build directory"
cd ninja_build
checkStatus $? "change build directory"
cmake -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR ..
checkStatus $? "cmake"

# build
make
checkStatus $? "make"

# install
make install
checkStatus $? "make install"

#
cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

touch "ninja-$VERSION-ok"
checkStatus $? "touch ninja-$VERSION-ok"