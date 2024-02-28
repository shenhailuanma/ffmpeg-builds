#!/bin/sh

# handle arguments
echo "Arguments: $@"
SCRIPT_DIR=$1
SOURCE_DIR=$2
BUILD_DIR=$3
INSTALL_DIR=$4
VERSION=$5
SKIP_X265_MULTIBIT=$6

# load functions
. $SCRIPT_DIR/functions.sh

# start in working directory
cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

# check whether it has been completed
if [ -f "x265-$VERSION-ok" ]; then
  echo "x265 has been completed"
  exit 0
fi

# cp source file
cp -r $SOURCE_DIR/x265_$VERSION.tar.gz ./
checkStatus $? "cp -r $SOURCE_DIR/x265_$VERSION.tar.gz ./"

# unpack
tar -zxf "x265_$VERSION.tar.gz"
checkStatus $? "unpack x265_$VERSION.tar.gz"
cd x265_$VERSION
checkStatus $? "cd x265_$VERSION"


if [ $SKIP_X265_MULTIBIT = "NO" ]; then
    # prepare build 10 bit
    echo "start with 10bit build"
    mkdir -p 10bit
    checkStatus $? "mkdir 10bit"
    cd 10bit/
    checkStatus $? "cd 10bit/"
    cmake -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR -DENABLE_SHARED=NO -DENABLE_CLI=OFF -DEXPORT_C_API=OFF -DHIGH_BIT_DEPTH=ON ../source
    checkStatus $? "cmake"

    # build 10 bit
    make
    checkStatus $? "make"
    cd ..
    checkStatus $? "cd .."

    # prepare build 12 bit
    echo "start with 12bit build"
    mkdir -p 12bit
    checkStatus $? "mkdir 12bit"
    cd 12bit/
    checkStatus $? "cd 12bit/"
    cmake -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR -DENABLE_SHARED=NO -DENABLE_CLI=OFF -DEXPORT_C_API=OFF -DHIGH_BIT_DEPTH=ON -DMAIN12=ON ../source
    checkStatus $? "cmake"

    # build 12 bit
    make
    checkStatus $? "make"
    cd ..
    checkStatus $? "cd .."

    # prepare build 8 bit
    echo "start with 8bit build"
    ln -s 10bit/libx265.a libx265_10bit.a
    checkStatus $? "symlink creation of 10 bit library"
    ln -s 12bit/libx265.a libx265_12bit.a
    checkStatus $? "symlink creation of 12 bit library"
    cmake -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR -DENABLE_SHARED=NO -DENABLE_CLI=OFF \
        -DEXTRA_LINK_FLAGS=-L. -DEXTRA_LIB="x265_10bit.a;x265_12bit.a" -DLINKED_10BIT=ON -DLINKED_12BIT=ON source
    checkStatus $? "configuration 8 bit"

    # build 8 bit
    make
    checkStatus $? "build 8 bit"

    # merge libraries
    mv libx265.a libx265_8bit.a
    checkStatus $? "move 8 bit library"
    if [ "$(uname)" = "Linux" ]; then
    ar -M <<EOF
CREATE libx265.a
ADDLIB libx265_8bit.a
ADDLIB libx265_10bit.a
ADDLIB libx265_12bit.a
SAVE
END
EOF
    else
        libtool -static -o libx265.a libx265_8bit.a libx265_10bit.a libx265_12bit.a
    fi
    checkStatus $? "multi-bit library creation"
else
    # prepare build
    cmake -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR -DENABLE_SHARED=NO -DENABLE_CLI=OFF source
    checkStatus $? "cmake"

    # build
    make
    checkStatus $? "make"
fi

# install
make install
checkStatus $? "make install"

# post-installation
# modify pkg-config file for usage with ffmpeg (it seems that the flag for threads is missing)
# --> https://bitbucket.org/multicoreware/x265_git/issues/371/x265-not-found-using-pkg-config
sed -i.original -e 's/lx265/lx265 -lpthread/g' $INSTALL_DIR/lib/pkgconfig/x265.pc

cd "$BUILD_DIR"
checkStatus $? "change directory to ${BUILD_DIR}"

touch "x265-$VERSION-ok"
checkStatus $? "touch x265-$VERSION-ok"