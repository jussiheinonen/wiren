
#!/usr/bin/env bash
#
# Create localstack resources for local development


awsConfig() {
    test -d ${HOME}/.aws || mkdir -p ${HOME}/.aws
    echo '[default]' > ${HOME}/.aws/config
    echo 'region = localhost' >> ${HOME}/.aws/config
}

awsCredentials() {
    echo '[default]' > ${HOME}/.aws/credentials
    echo 'aws_access_key_id = whatever' >> ${HOME}/.aws/credentials
    echo 'aws_secret_access_key = whatever' >> ${HOME}/.aws/credentials
}

checkAndSetAwsCredentials() {
    if [[ -f ${HOME}/.aws/credentials ]]; then
        read -p "WARNING! ${HOME}/.aws/credentials already exist. Overwrite ? [y/n] " overwrite
    else 
        overwrite="y"
    fi

    if [[ "${overwrite}" == "y" ]]; then
        awsConfig
        awsCredentials
    else
        echo "Skipping aws cli config"
    fi
}

createBucket() {
    for each in $*; do
        info "Creating bucket ${each}"
        aws s3 mb s3://${each} --endpoint-url http://localhost:4566
    done
}

errorAndExit() {
    echo "$1"
    exit $2
}

info() {
    echo "${1}"
}

checkAndSetAwsCredentials
createBucket ocr-inbound