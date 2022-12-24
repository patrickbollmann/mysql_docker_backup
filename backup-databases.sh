#!/bin/bash

# Backup Script for mysql database docker container
# ---
# This script can be used to backup the configured databases from an mysql docker container
# 

databases=( "database1" "database2" "database3")    #list of databases to backup

DAYS=90
BACKUPDIR=/home/db-backups

if [ ! -d $BACKUPDIR ]; then
    mkdir -p $BACKUPDIR
fi

CONTAINER=mysql #name of the mysql docker container
MYSQL_PWD=$(docker exec $CONTAINER env | grep MYSQL_ROOT_PASSWORD |cut -d"=" -f2)   #get the mysql root password from the container

for MYSQL_DATABASE in "${databases[@]}"
do
    echo "Backing up $MYSQL_DATABASE"
    docker exec -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_PWD=$MYSQL_PWD \
        $CONTAINER /usr/bin/mysqldump -u root $MYSQL_DATABASE \
        | gzip > $BACKUPDIR/$CONTAINER-$MYSQL_DATABASE-$(date +"%Y%m%d%H%M").sql.gz

    OLD_BACKUPS=$(ls -1 $BACKUPDIR/$CONTAINER*.gz |wc -l)
    if [ $OLD_BACKUPS -gt $DAYS ]; then
        find $BACKUPDIR -name "$i*.gz" -daystart -mtime +$DAYS -delete
    fi
done

echo "Backup for Databases completed"
