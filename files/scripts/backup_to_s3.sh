#!/bin/bash
set -x

#### BEGIN CONFIGURATION ####

# set dates for backup rotation
NOWDATE=`date +%Y-%m-%d-%H-%M`
DAY_OF_MONTH=`date +%d`
EXPIRE=true
if  [ $DAY_OF_MONTH = 01 ] ;
then
    EXPIRE=false
fi

# set backup directory variables
SRCDIR='/tmp/s3backups_who'
DESTDIR='who'
SHORT_TERM_BUCKET='dc-ee-short-term-backups'

# database access details
HOST='127.0.0.1'
PORT='5432'
USER='{{ project_name }}'
DB='{{ project_name }}'


#### END CONFIGURATION ####

# make the temp directory if it doesn't exist
mkdir -p $SRCDIR

pg_dump  -Fc $DB -f $SRCDIR/$NOWDATE-backup.dump

# # upload backup to s3
/usr/local/bin/s3cmd put $SRCDIR/$NOWDATE-backup.dump s3://$SHORT_TERM_BUCKET/$DESTDIR/

/usr/local/bin/s3cmd expire s3://$SHORT_TERM_BUCKET


#remove all files in our source directory
cd
rm -f $SRCDIR/*
