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



# build x264

# build x265
START_TIME=$(currentTimeInSeconds)
echoSection "To compile x265"
$SCRIPT_DIR/build-x265.sh "$SCRIPT_DIR" "$SOURCE_DIR" "$BUILD_DIR" "$INSTALL_DIR" "3.2" "NO" > "$LOG_DIR/build-x265.log" 2>&1
checkStatus $? "build x265"
echoDurationInSections $START_TIME
FFMPEG_LIB_FLAGS="$FFMPEG_LIB_FLAGS --enable-libx265"
REQUIRES_GPL="YES"

# build heic

# build ffmpeg
START_TIME=$(currentTimeInSeconds)
echoSection "To compile ffmpeg"

echo "FFMPEG_LIB_FLAGS:$FFMPEG_LIB_FLAGS"
echo "REQUIRES_GPL:$REQUIRES_GPL"

echoDurationInSections $START_TIME