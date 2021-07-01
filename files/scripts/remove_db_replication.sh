#!/bin/bash
set -x

USER={{ project_name }}
INSTANCE_ID=`curl http://instance-data/latest/meta-data/instance-id`
SUBSCRIPTION=${USER}_${INSTANCE_ID:2}

psql -U $USER -c "DROP SUBSCRIPTION $SUBSCRIPTION;"
touch {{ project_root }}/home/server_dirty