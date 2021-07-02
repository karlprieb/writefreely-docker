#!/bin/sh
set -e

CONFIG_FILE=/config/config.ini
DB_FILE=/data/writefreely.db
KEY_FILE=/data/keys/email.aes256
WRITEFREELY="/writefreely/writefreely -c ${CONFIG_FILE}"

if [ ! -s ${CONFIG_FILE} ]; then
    echo "ERROR: no config.ini file"
    exit 0
fi

if [ ! -d "/data/templates" ]; then
    echo "Copying default templates"
    cp -r /writefreely/templates/ /data/templates/
fi

if [ ! -d "/data/pages" ]; then
    echo "Copying default pages"
    cp -r /writefreely/pages/ /data/pages/
fi

if [ -e ${DB_FILE} ] && [ -e ${KEY_FILE} ]; then
    BACKUP="writefreely.$(date +%s).db"
    cp ${DB_FILE} /data/${BACKUP}
    ${WRITEFREELY} -migrate
    if cmp ${DB_FILE} /data/${BACKUP}; then
        rm /data/${BACKUP}
    else
        echo "Database backed up at /data/${BACKUP}"
    fi
    exec ${WRITEFREELY}
fi

if [ ! -s ${DB_FILE} ]; then
    ${WRITEFREELY} -init-db
    ${WRITEFREELY} -create-admin $USERNAME:$PASSWORD
fi

if [ ! -e ${KEY_FILE} ]; then
    ${WRITEFREELY} -gen-keys
fi

exec ${WRITEFREELY}
