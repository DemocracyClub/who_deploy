#!/bin/bash
set -xeEo pipefail

# rotate the log file otherwise output is lost in cloudwatch
echo "" > /var/log/db_replication/logs.log
# write the env file
/var/www/wcivf/env/bin/python /var/www/wcivf/code/deployscripts/write_envfile.py
# ensure the file exists - if not script exits with error
cat /var/www/wcivf/code/.env | xargs
# now load .env file to get RDS secrets
export $(cat /var/www/wcivf/code/.env | xargs)
USER={{ project_name }}
DB={{ project_name }}
INSTANCE_ID=`curl http://instance-data/latest/meta-data/instance-id`
SUBSCRIPTION=${USER}_${INSTANCE_ID:2}

dropdb --if-exists $DB -U $USER
createdb $DB -U $USER
source {{ project_root }}/env/bin/activate && {{ project_root }}/code/manage.py migrate
source {{ project_root }}/env/bin/activate && {{ project_root }}/code/manage.py flush --no-input
source {{ project_root }}/env/bin/activate && {{ project_root }}/code/manage.py truncate_replicated_tables
psql $DB -U $USER -c "CREATE SUBSCRIPTION $SUBSCRIPTION CONNECTION 'dbname=$RDS_DB_NAME host=$RDS_HOST user=$USER password=$RDS_DB_PASSWORD' PUBLICATION alltables;"
rm -f /var/www/wcivf/home/server_dirty
