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
        endpoint_url = 'http://localhost:8000',
        aws_access_key_id = 'AKIAIOSFODNN7EXAMPLE',
        aws_secret_access_key = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
    )
else:
    client = boto3.client('dynamodb')

@app.route("/")
def hello():
    #return "You are in the root. Try /greeting resource."
    return "NODE_VERSION: " + os.environ['NODE_VERSION']

@app.route("/greeting")
def greeting():
    return "Hi there!"

@app.route("/users/<string:user_id>")
def get_user(user_id):
    resp = client.get_item(
        TableName=USERS_TABLE,
        Key={
            'userId': { 'S': user_id }
        }
    )
    item = resp.get('Item')
    if not item:
        return jsonify({'error': 'User does not exist'}), 404

    return jsonify({
        'userId': item.get('userId').get('S'),
        'name': item.get('name').get('S')

    })