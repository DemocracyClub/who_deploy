#!/bin/sh
set -x

# Get the latest backup file
LATEST_FILE=`s3cmd ls s3://dc-ee-short-term-backups/who/ | sort | tail -n 1 | rev | cut -d' ' -f 1 | rev`
FILENAME=`echo $LATEST_FILE | rev | cut -d '/' -f 1 | rev`
SRCDIR='/tmp/s3backups_{{ project_name }}'
mkdir -p $SRCDIR


# database access details
HOST='127.0.0.1'
PORT='5432'
USER='{{ project_name }}'
DB={{ project_name }}


echo $FILENAME
s3cmd get --skip-existing $LATEST_FILE $SRCDIR --region=eu-west-2
dropdb --if-exists $DB
createdb $DB
pg_restore -U $USER  -d $DB  $SRCDIR/$FILENAME
rm $SRCDIR/*
