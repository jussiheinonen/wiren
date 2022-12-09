#!/usr/bin/env python3

from app import lambda_handler
import os, boto3, argparse

def mockS3Trigger(bucket, key):
    event = dict(
            {
                "Records": [
                {
                    "s3": {
                    "bucket": {
                        "name": bucket
                    },
                    "object": {
                        "key": key
                    }
                    }
                }
                ]
            }
    )

    return event

parser = argparse.ArgumentParser(description='Process a file inS3 bucket')
parser.add_argument('-f', '--filename', dest='filename', required=True, help="file to process")
parser.add_argument('-b', '--bucket', dest='bucket', required=True, help="S3 bucket name")
args = parser.parse_args()

key = args.filename
bucket = args.bucket

event = mockS3Trigger(bucket, key)

results = lambda_handler(event, None)

print(f'Received: {results}')
