#!/usr/bin/env bash
#
# Start serverless-dynamodb-local before starting web server 
#
# USAGE: ./entrypoint.sh 

export USERS_TABLE="users"
export IS_OFFLINE="true"

sls dynamodb start &
sleep 3
sls wsgi serve
