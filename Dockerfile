FROM node:alpine
LABEL maintainer="heinonen.jussi@gmail.com"

# Development environment for Python3 and Node.js
#
# SLS runtime based on https://www.serverless.com/blog/flask-python-rest-api-serverless-lambda-dynamodb
# AWS SAM runtime based https://gist.github.com/gmoon/3800dd80498d242c4c6137860fe410fd
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

WORKDIR /usr/app/

RUN apk update && apk add python3 bash net-tools curl file exiftool jq && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    pip3 install --upgrade pip && \
    pip3 install flask boto3 awscli exif IPTCInfo3 exifread && \
    npm install -g npm serverless && \
    npm install --save-dev serverless-wsgi serverless-python-requirements 

# INSTALL AWS SAM RUNTIME
RUN apk add musl-dev gcc python3-dev git && \
    pip3 install --upgrade aws-sam-cli
    
ENTRYPOINT ["wiren/entrypoint.sh"] 



