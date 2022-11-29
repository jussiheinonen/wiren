FROM node:alpine3.15
LABEL maintainer="heinonen.jussi@gmail.com"
#
# TODO: Bump to node:alpine latest once Python v3.10 is supported Lambda runtime
#       Until that fix it to Alpine 3.15 that supports Python 3.9
#
# Development environment for Python3 and Node.js
#
# SLS runtime based on https://www.serverless.com/blog/flask-python-rest-api-serverless-lambda-dynamodb
# AWS SAM runtime based https://gist.github.com/gmoon/3800dd80498d242c4c6137860fe410fd
# 
# Base image provides Node runtime on Alpine linux
# Atop install Python 3.8, Node serverless modules and tools
# 
#
# PULL:  docker pull node:alpine
# BUILD: docker build -t wiren:alpine_3.15 ./$(dirname $0)
# BUILD FROM SCRATCH:  docker build --no-cache --pull -t wiren:alpine ./$(dirname $0)
# USAGE: docker run -v $(pwd)/wiren:/usr/app/wiren --net=host -it wiren:alpine
#        Open http://localhost:5000/ in the web browser
#

WORKDIR /usr/app/

RUN apk update && apk add python3 py3-pip bash net-tools curl file exiftool jq groff && \
    #ln -s /usr/bin/python3 /usr/bin/python && \
    #ln -s /usr/bin/pip3 /usr/bin/pip && \
    /usr/bin/pip3 install --upgrade pip && \
    /usr/bin/pip3 install flask boto3 awscli exif IPTCInfo3 exifread requests && \
    npm install -g npm serverless && \
    npm install --save-dev serverless-wsgi serverless-python-requirements 

# INSTALL AWS SAM RUNTIME
RUN apk add musl-dev gcc python3-dev git && \
    /usr/bin/pip3 install --upgrade aws-sam-cli
    
ENTRYPOINT ["wiren/entrypoint.sh"] 



