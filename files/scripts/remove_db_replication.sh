#!/bin/bash
set -ex

USER={{ project_name }}
INSTANCE_ID=`curl http://instance-data/latest/meta-data/instance-id`
SUBSCRIPTION=${USER}_${INSTANCE_ID:2}

drop_subscription () {
    psql -U $USER -c "DROP SUBSCRIPTION $SUBSCRIPTION;"
}

# if subscription is active it will fail - repeat until inactive
until drop_subscription; do
    echo "Trying to drop subscription again..."
done

echo "Subscription dropped"
touch {{ project_root }}/home/server_dirty
