#!/bin/bash

# some folder names
BASE_DIR="$( cd "$( dirname "$0" )" > /dev/null 2>&1 && pwd )"
echo "BASE_DIR:${BASE_DIR}"

SCRIPT_DIR="${BASE_DIR}/scripts"
echo "SCRIPT_DIR:${SCRIPT_DIR}"
SOURCE_DIR="${BASE_DIR}/sources"
echo "SOURCE_DIR:is ${SOURCE_DIR}"

WORKING_DIR="$( pwd )"
echo "WORKING_DIR:${WORKING_DIR}"
LOG_DIR="$WORKING_DIR/log"
echo "LOG_DIR:${LOG_DIR}"
INSTALL_DIR="$WORKING_DIR/install"
echo "INSTALL_DIR:${INSTALL_DIR}"
BUILD_DIR="$WORKING_DIR/build"
echo "BUILD_DIR:${BUILD_DIR}"


# load functions
. $SCRIPT_DIR/functions.sh


# prepare workspace
echoSection "prepare workspace"
mkdir -p "$LOG_DIR"
checkStatus $? "To create LOG_DIR:${LOG_DIR}"
mkdir -p "$INSTALL_DIR"
checkStatus $? "To create INSTALL_DIR:${INSTALL_DIR}"
mkdir  -p "$BUILD_DIR"
checkStatus $? "To create BUILD_DIR:${BUILD_DIR}"


echo "system info: $(uname -a)"
COMPILATION_START_TIME=$(currentTimeInSeconds)
PATH="$INSTALL_DIR/bin:$PATH"
echo "PATH:$PATH"

# prepare build
FFMPEG_LIB_FLAGS=""
REQUIRES_GPL="NO"
REQUIRES_NON_FREE="NO"


# build nasm
START_TIME=$(currentTimeInSeconds)
echoSection "To compile nasm"
$SCRIPT_DIR/build-nasm.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "2.16.01" > "$LOG_DIR/build-nasm.log" 2>&1
checkStatus $? "build nasm"
echoDurationInSections $START_TIME

# build pkg-config
START_TIME=$(currentTimeInSeconds)
echoSection "compile pkg-config"
$SCRIPT_DIR/build-pkg-config.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "0.29.2" > "$LOG_DIR/build-pkg-config.log" 2>&1
checkStatus $? "build pkg-config"
echoDurationInSections $START_TIME

# build libtool
START_TIME=$(currentTimeInSeconds)
echoSection "compile libtool"
$SCRIPT_DIR/build-libtool.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "2.4.6" > "$LOG_DIR/build-libtool.log" 2>&1
checkStatus $? "build libtool"
echoDurationInSections $START_TIME

START_TIME=$(currentTimeInSeconds)
echoSection "compile zlib"
$SCRIPT_DIR/build-zlib.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "1.3.1" > "$LOG_DIR/build-zlib.log" 2>&1
checkStatus $? "build zlib"
echoDurationInSections $START_TIME


# build openssl
START_TIME=$(currentTimeInSeconds)
echoSection "To compile openssl"
$SCRIPT_DIR/build-openssl.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "3.2.1" > "$LOG_DIR/build-openssl.log" 2>&1
checkStatus $? "build openssl"
echoDurationInSections $START_TIME

# build cmake
START_TIME=$(currentTimeInSeconds)
echoSection "To compile cmake"
$SCRIPT_DIR/build-cmake.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "3.28.3" > "$LOG_DIR/build-cmake.log" 2>&1
checkStatus $? "build cmake"
echoDurationInSections $START_TIME

START_TIME=$(currentTimeInSeconds)
echoSection "compile ninja"
$SCRIPT_DIR/build-ninja.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "1.11.1" > "$LOG_DIR/build-ninja.log" 2>&1
checkStatus $? "build ninja"
echoDurationInSections $START_TIME

START_TIME=$(currentTimeInSeconds)
echoSection "compile libxml2"
$SCRIPT_DIR/build-libxml2.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "v2.12.5" > "$LOG_DIR/build-libxml2.log" 2>&1
checkStatus $? "build libxml2"
echoDurationInSections $START_TIME

START_TIME=$(currentTimeInSeconds)
echoSection "compile fribidi"
$SCRIPT_DIR/build-fribidi.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "1.0.13" > "$LOG_DIR/build-fribidi.log" 2>&1
checkStatus $? "build fribidi"
echoDurationInSections $START_TIME




### codecs ###

# build x264
START_TIME=$(currentTimeInSeconds)
echoSection "compile x264"
$SCRIPT_DIR/build-x264.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "20240229" > "$LOG_DIR/build-x264.log" 2>&1
checkStatus $? "build x264"
echoDurationInSections $START_TIME
FFMPEG_LIB_FLAGS="$FFMPEG_LIB_FLAGS --enable-libx264"
REQUIRES_GPL="YES"


# build x265
START_TIME=$(currentTimeInSeconds)
echoSection "To compile x265"
$SCRIPT_DIR/build-x265.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "3.2" "NO" > "$LOG_DIR/build-x265.log" 2>&1
checkStatus $? "build x265"
echoDurationInSections $START_TIME
FFMPEG_LIB_FLAGS="$FFMPEG_LIB_FLAGS --enable-libx265"
REQUIRES_GPL="YES"

# build libheif
START_TIME=$(currentTimeInSeconds)
echoSection "To compile libheif"
$SCRIPT_DIR/build-libheif.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "1.17.6" > "$LOG_DIR/build-libheif.log" 2>&1
checkStatus $? "build libheif"
echoDurationInSections $START_TIME
# FFMPEG_LIB_FLAGS="$FFMPEG_LIB_FLAGS --enable-libheif"
# REQUIRES_GPL="YES"


# build ffmpeg
START_TIME=$(currentTimeInSeconds)
echoSection "To compile ffmpeg"

echo "FFMPEG_LIB_FLAGS:$FFMPEG_LIB_FLAGS"
echo "REQUIRES_GPL:$REQUIRES_GPL"

echoDurationInSections $START_TIME


START_TIME=$(currentTimeInSeconds)
echoSection "compile ffmpeg"
$SCRIPT_DIR/build-ffmpeg.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "6.1.1" "$FFMPEG_LIB_FLAGS" > "$LOG_DIR/build-ffmpeg.log" 2>&1
checkStatus $? "build ffmpeg"
echoDurationInSections $START_TIME

echoSection "compilation finished successfully"
echoDurationInSections $COMPILATION_START_TIME
