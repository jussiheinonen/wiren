#!/usr/bin/env bash
#
# Push container image to ECR
#
# NOTE! Before attempting to push image to ECR, ensure you've set correct IAM permissions for ecr:* services
#       Example permission set https://github.com/jussiheinonen/ltd.noooner.dam.core/commit/c5c2ccf29561109ef4a2b6be4729d78f8946d59f
#
# USAGE: ./push.sh --image_name=image_name --image_version=image_version [--aws_account_id=aws_account_id] [--aws_region=aws_region] [--ecr_endpoint=ecr-endpoint]
#
#
#

declare -A ARGS

errorAndExit() {
    echo $1
    exit $2
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
      errorAndExit "Argument must contain = character as in --key=value"
    fi
  done
}


processCliArgs $@

usage() {
  echo "USAGE: $0 --image_name=image_name --image_version=image_version [--aws_account_id=aws_account_id] [--aws_region=aws_region] [--ecr_endpoint=ecr-endpoint]"
  exit 0
}

test -z ${ARGS[--image_name]} && ARGS[--image_name]=${1:-${IMAGE_NAME}}
test -z ${ARGS[--image_version]} && ARGS[--image_version]=${2:-${IMAGE_VERSION}}
test -z ${ARGS[--aws_account_id]} && ARGS[--aws_account_id]=${3:-"354080235170"}
test -z ${ARGS[--aws_region]} && ARGS[--aws_region]=${4:-"eu-west-1"}
test -z ${ARGS[--ecr_endpoint]} && ARGS[--ecr_endpoint]="${ARGS[--aws_account_id]}.dkr.ecr.${ARGS[--aws_region]}.amazonaws.com"

test -z ${ARGS[--image_name]} && usage
test -z ${ARGS[--image_version]} && usage


# Check whether to install aws clis
which aws &>/dev/null || errorAndExit "Failed to find AWS CLI binary" 1

echo "Set AWS region"
aws configure set default.region ${ARGS[--aws_region]}

echo "Login to ECR"
$(aws ecr get-login --no-include-email)

echo "Verify repository exists"
aws ecr describe-repositories --repository-names ${ARGS[--image_name]}} &>/dev/null || \
aws ecr create-repository --repository-name ${ARGS[--image_name]}

echo "Tag image"
docker tag ${ARGS[--image_name]}:${ARGS[--image_version]} \
  ${ARGS[--ecr_endpoint]}/${ARGS[--image_name]}:${ARGS[--image_version]}
docker tag ${ARGS[--ecr_endpoint]}/${ARGS[--image_name]}:${ARGS[--image_version]} \
  ${ARGS[--ecr_endpoint]}/${ARGS[--image_name]}:latest

echo "Pushing container to ECR"
docker push ${ARGS[--ecr_endpoint]}/${ARGS[--image_name]}