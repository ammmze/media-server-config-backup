#!/bin/bash

SERVICES=("sabnzbdplus" "sickbeard" "couchpotato" "plexmediaserver")

DIR="$( cd "$( dirname "$0" )" && pwd )"
ROOT=$DIR/root
if [ "$1" != "" ]; then
    ROOT=$1
fi

stop_everything () {
    echo -e "\e[00;36mStopping Services\e[00m"
    for i in "${SERVICES[@]}"
    do :
        service $i stop
    done
    echo ""
}

start_everything () {
    echo -e "\e[00;36mStarting Services\e[00m"
    for i in "${SERVICES[@]}"
    do :
        service $i start
    done
    echo""
}

copy_config () {
    echo -e "\e[00;36mCopying data from backup\e[00m"
    cp -r $ROOT/* /
    echo -e "\e[01;36mFinished copying data from backup\e[00m"
    echo ""
}

echo -e "\e[00;32mBeginning Restoration\e[00m"
echo "---------------------"
echo ""

stop_everything

copy_config

start_everything

