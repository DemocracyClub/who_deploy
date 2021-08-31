#!/bin/bash
set -xeE

# load .env file to get RDS secrets
export $(cat ./code/.env | xargs)
USER={{ project_name }}
DB={{ project_name }}
INSTANCE_ID=`curl http://instance-data/latest/meta-data/instance-id`
SUBSCRIPTION=${USER}_${INSTANCE_ID:2}

dropdb --if-exists $DB -U $USER
createdb $DB -U $USER
source {{ project_root }}/env/bin/activate && {{ project_root }}/code/manage.py migrate
psql $DB -U $USER -c "CREATE SUBSCRIPTION $SUBSCRIPTION CONNECTION 'dbname=$RDS_DB_NAME host=$RDS_HOST user=$USER password=$RDS_DB_PASSWORD' PUBLICATION alltables;"
rm -f /var/www/wcivf/home/server_dirty
