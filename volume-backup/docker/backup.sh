#!/bin/sh

usage() {
  >&2 echo "Usage: volume-backup <backup|restore> <archive>"
}

backup() {
    if [ -z "$(ls -A /volume)" ]; then
       >&2 echo "Volume is empty or missing, check if you specified a correct name"
       exit 1
    fi

    ARCHIVE_DIR=${ARCHIVE_PATH%%$EXTENSION}
    mkdir -p $ARCHIVE_DIR

    for SUB in $(ls -A /volume); do
        if ! [ -z "$(ls -A /volume/$SUB)" ]; then
            tar -C /volume/$SUB -j -cf $ARCHIVE_DIR/$SUB$EXTENSION ./
        fi
    done
}

restore() {
    if ! [ -e $ARCHIVE_PATH ]; then
        >&2 echo "Archive file $ARCHIVE_PATH does not exist"
        exit 1
    fi

    SUB=$(basename $ARCHIVE_PATH)
    SUB=${SUB%%$EXTENSION}

    rm -rf /volume/$SUB/* /volume/$SUB/..?* /volume/$SUB/.[!.]*
    tar -C /volume/$SUB/ -j -xf $ARCHIVE_PATH
}

sleep 1

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

OPERATION=$1

shift

EXTENSION=.tar.bz2

if [ $# -eq 0 -a "$OPERATION" = "backup" ]; then
    ARCHIVE=$(date +%Y%m%d-%H%M%S)$EXTENSION
elif [ $# -ne 1 ]; then
    usage
    exit 1
else
    ARCHIVE=${1%%$EXTENSION}$EXTENSION
fi

ARCHIVE_PATH=/backup/$ARCHIVE

case "$OPERATION" in
    "backup" )
        backup
        ;;
    "restore" )
        restore
        ;;
    * )
        usage
        exit 1
        ;;
esac

exit 0

# END
