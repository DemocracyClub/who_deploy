#!/bin/bash
set -x

DB={{ project_name }}
USER={{ project_name }}
RDS_HOST={{ vault_rds_host }}
RDS_PASSWORD='{{ vault_rds_password }}'
INSTANCE_ID=`curl http://instance-data/latest/meta-data/instance-id`
SUBSCRIPTION=${USER}_${INSTANCE_ID:2}

dropdb --if-exists $DB -U $USER
createdb $DB -U $USER
source {{ project_root }}/env/bin/activate && {{ project_root }}/code/manage.py migrate
psql $DB -U $USER -c "CREATE SUBSCRIPTION $SUBSCRIPTION CONNECTION 'dbname=$DB host=$RDS_HOST user=$USER password=$RDS_PASSWORD' PUBLICATION alltables;"
rm -f /var/www/wcivf/home/server_dirty
