# app.py

import os, boto3

from flask import Flask,  jsonify, request

app = Flask(__name__)

USERS_TABLE = os.environ['USERS_TABLE']
IS_OFFLINE = os.environ.get('IS_OFFLINE')

if IS_OFFLINE:
    client = boto3.client(
        'dynamodb',
        region_name = 'localhost',
        endpoint_url = 'http://localhost:8000'
    )
else:
    client = boto3.client('dynamodb')

@app.route("/")
def hello():
    return jsonify(os.environ)

@app.route("/greeting")
def greeting():

    return "Hi there!"