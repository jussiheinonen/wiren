FROM node:alpine
LABEL maintainer="heinonen.jussi@gmail.com"

# Development environment for Python and Node.js development
#
# Based on https://www.serverless.com/blog/flask-python-rest-api-serverless-lambda-dynamodb
# 
# Base image provides Node runtime on Alpine linux
# Atop install Python 3.8, Node serverless modules and tools
# 
#
# BUILD: sudo docker build -t wiren:alpine ./$(dirname $0)
# BUILD FROM SCRATCH: sudo docker build --no-cache --pull -t wiren:alpine ./$(dirname $0)
# USAGE: sudo docker run -v $(pwd)/wiren:/usr/app/wiren --net=host -it wiren:alpine
#        Open http://localhost:5000/ in the web browser
#
# TODO: sls dynamodb crashes. 
#       Workaround based on https://github.com/localstack/localstack/issues/2619
#       Download https://github.com/whummer/dynamodb-local/raw/master/etc/DynamoDBLocal.zip and extract in wiren/.dynamodb
#       Then run wiren/entrypoint.sh and alles gut supposed to

WORKDIR /usr/app/

RUN apk update && apk add python3 bash net-tools openjdk11-jre curl file exiftool && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    pip3 install --upgrade pip && \
    pip3 install flask boto3 awscli exif && \
    npm install -g npm serverless && \
    npm install --save-dev serverless-wsgi serverless-python-requirements serverless-dynamodb-local

ENTRYPOINT ["wiren/entrypoint.sh"] 



