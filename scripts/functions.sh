#!/bin/bash

function log_info()
{
    datestring=`date "+%Y-%m-%d"`
    timestring=`date "+%H:%M:%S"`
    echo -e "\033[32m[Info ][$datestring $timestring]" "$1 \033[0m"
}

function log_warn()
{
    datestring=`date "+%Y-%m-%d"`
    timestring=`date "+%H:%M:%S"`
    echo -e "\033[33m[Warn ][$datestring $timestring]" "$1 \033[0m"
}

function log_error()
{
    datestring=`date "+%Y-%m-%d"`
    timestring=`date "+%H:%M:%S"`
    echo -e "\033[31m[Error][$datestring $timestring]" "$1 \033[0m"
}

# params:
#   $1 : status
#   $2 : message
function checkStatusColor() {
    if [ $1 -eq 0 ];then
        log_info "[SUCCESS] $2"
    else
        log_error "[FAILED] $2"
        exit 1
    fi
}
function checkStatus() {
    if [ $1 -eq 0 ];then
        echo "[SUCCESS] $2"
    else
        echo "[FAILED] $2"
        exit 1
    fi
}

echoSection(){
    echo ""
    echo "$1"
}

currentTimeInSeconds(){
    TIME_GDATE=$(date +%s)
    if [ $? -eq 0 ]
    then
        echo $TIME_GDATE
    else
        echo 0
    fi
}

echoDurationInSections(){
    END_TIME=$(currentTimeInSeconds)
    echo "Took time $(($END_TIME - $1))s"
}

download(){
    URL=$1
    NAME=$2
    curl -o "$NAME" -L -f "$URL"
}
