#!/usr/bin/env bash
#
# Start serverless-dynamodb-local before starting web server 
#
# USAGE: ./entrypoint.sh 

export USERS_TABLE="users-table-dev"
export IS_OFFLINE="true"

cd ./$(dirname $0)
sls dynamodb start &
sleep 3
sls wsgi serve
