#!/bin/bash

SERVICES=("sabnzbdplus" "sickbeard" "couchpotato" "plexmediaserver")

DIR="$( cd "$( dirname "$0" )" && pwd )"
ROOT=$DIR/root
if [ "$1" != "" ]; then
    ROOT=$1
fi

CONFIG=(\
    "/etc/samba/smb.conf"\
    "/etc/snapraid.conf"\
    #"/etc/fstab"\
    "/home/mediaserver/.couchpotato/config.ini"\
    "/home/mediaserver/.couchpotato/data.db"\
    "/home/mediaserver/.sabnzbd/sabnzbd.ini"\
    "/home/mediaserver/.sickbeard/config.ini"\
    "/home/mediaserver/.sickbeard/sickbeard.db"\
    "/home/mediaserver/.sickbeard/autoProcessTV/autoProcessTV.cfg"\
    "/home/mediaserver/plex-9-to-trakt.php"\
    "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/"\
    )

EXCLUDE=(\
    "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins/"\
    #"/Plug-ins/"\
    )

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
    echo -e "\e[00;36mCopying configuration files\e[00m"
    EXCLUDE_STR=""
    for i in "${EXCLUDE[@]}"
    do :
        EXCLUDE_STR="--filter=\"-/ $i\" $EXCLUDE_STR"
    done

    for i in "${CONFIG[@]}"
    do :
        
        CFG="$ROOT$i"
        if [ -d "$i" ]; then
            
            echo "Copying Config Directory: $i"
            CFG_PATH=`dirname "$CFG"`
            DEST=$ROOT$i
            mkdir -p "$CFG_PATH"
            CMD="rsync -az $EXCLUDE_STR \"$i\" \"$DEST\""
            eval $CMD 

        elif [ -f "$i" ]; then
            
            echo "Copying Config File: $i"
            CFG_PATH=`dirname "$CFG"`
            mkdir -p "$CFG_PATH"
            cp "$i" "$ROOT$i"

        else

            echo "Could not find $i"

        fi
    done
    echo ""
}

echo -e "\e[00;32mBeginning Backup\e[00m"
echo "----------------"
echo ""

stop_everything

copy_config

start_everything

