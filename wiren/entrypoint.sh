#!/usr/bin/env bash
#
# Start serverless-dynamodb-local before starting web server 
#
# USAGE: ./entrypoint.sh --start_dynamodb=true --start_wsgi=true --wsgi_dir=../core/core

export USERS_TABLE="users-table-dev"
export IS_OFFLINE="true"

info() {
  echo -e "\e[34m ${1}\e[0m"
}

printCliArgs() {
  for each in "${!ARGS[@]}"
  do
    echo "ARGS[${each}]=${ARGS[${each}]}"
  done
}

processCliArgs() {
  #  Reads arguments into associative array ARGS[]
  #  Key-Value argument such as --myarg="argvalue" adds an element ARGS[--myarg]="argvalue"
  #
  #  USAGE: processCliArgs $*
  for each in $*; do
    if [[ "$(echo ${each} | grep '=' >/dev/null ; echo $?)" == "0" ]]; then
      key=$(echo ${each} | cut -d '=' -f 1)
      value=$(echo ${each} | cut -d '=' -f 2)
      if [[ "${ARGS[--debug]}" ]]; then
        if [[ "${key}" =~ "key" ]]; then
          info "Processing Key-Value argument ${key}=${value:0:4}********************"
        else
          info "Processing Key-Value argument ${key}=${value}"
        fi
      fi
      ARGS[${key}]="${value}"
    else
      errorAndExit "$0.${FUNCNAME}: Argument must contain = character as in --key=value" 1
    fi
  done
}

declare -A ARGS
processCliArgs $*
test -z ${ARGS[--start_dynamodb]} && ARGS[--start_dynamodb]="true"
test -z ${ARGS[--start_wsgi]} && ARGS[--start_wsgi]="true"
test -z ${ARGS[--wsgi_dir]} && ARGS[--wsgi_dir]="./$(dirname $0)"
printCliArgs

if [[ "${ARGS[--start_dynamoddb]}" == "true" ]]; then
  cd ./$(dirname $0)
  sls dynamodb start &
  sleep 3
fi

if [[ "${ARGS[--start_wsgi]}" == "true" ]]; then
    cd ${ARGS[--wsgi_dir]}
    sls wsgi serve
else
    info "--start_wsgi flag set to ${ARGS[--start_wsgi]}"
fi
