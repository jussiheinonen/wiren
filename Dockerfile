FROM node:alpine

# Development environment for Python and Node development
#
# Based on https://www.serverless.com/blog/flask-python-rest-api-serverless-lambda-dynamodb
# 
# Base image provides Node runtime on Alpine linux
# Atop install Python 3.8, Node serverless modules and tools
# 
#
# BUILD: sudo docker build --no-cache --pull -t wiren:alpine ./$(dirname $0)
# USAGE: sudo docker run -v $(pwd)/wiren:/usr/app/wiren --net=host -it wiren:alpine
# RUNNING WEB SERVER: 
#   1. export USERS_TABLE="users" && export IS_OFFLINE="true"
#   2. cd wiren && sls wsgi serve # Then open http://localhost:5000/  in your web browser

WORKDIR /usr/app

RUN apk update && apk add python3 bash net-tools && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    pip3 install --upgrade pip && \
    pip3 install flask boto3 awscli && \
    npm install -g serverless && \
    npm install --save-dev serverless-wsgi serverless-python-requirements serverless-dynamodb-local

ENTRYPOINT ["/bin/bash"] 



