FROM node:latest

# Based on https://www.serverless.com/blog/flask-python-rest-api-serverless-lambda-dynamodb
# Node base image is Debian9 based
# Bundled with npm and Python2.7/Python3
# Command `python` is an alias for python2.7
# To call Python3 use command `python3`
#
# BUILD: sudo docker build --no-cache --pull -t wiren:dev ./$(dirname $0)
# USAGE: sudo docker run -v $(pwd)/wiren:/usr/app/wiren -p 5000:5000 --net=host -it wiren:dev
# RUN WEB SERVER: cd wiren && sls wsgi serve # Then open http://localhost:5000/  in your web browser

WORKDIR /usr/app

RUN apt update && apt install -y vim nano python3-pip net-tools && \
    pip3 install flask boto3 awscli && \
    npm install -g serverless && \
    #npm install -g npm@7.5.3
    npm install --save-dev serverless-wsgi serverless-python-requirements serverless-dynamodb-local

ENTRYPOINT ["/bin/bash"] 



