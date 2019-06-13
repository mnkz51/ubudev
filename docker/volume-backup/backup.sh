#!/bin/sh

usage() {
  >&2 echo "Usage: backup <backup|restore> <archive>"
}

backup() {
    ls -A /volume
    if [ -z "$(ls -A /volume)" ]; then
       >&2 echo "Volume is empty or missing, check if you specified a correct name"
       exit 1
    fi

    # mkdir -p `dirname /backup/$ARCHIVE`
    ls -A /backup2
    echo $ARCHIVE_PATH

    tar -C /volume -j -cf $ARCHIVE_PATH ./
}

sleep 1

OPERATION=$1

shift

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

EXTENSION=.tar.bz2

ARCHIVE=${1%%$EXTENSION}$EXTENSION
ARCHIVE_PATH=/backup2/$ARCHIVE

case "$OPERATION" in
    "backup" )
        backup
        ;;
    "restore" )
        >&2 echo "restore"
        ;;
    * )
        usage
    ;;
esac

# END
