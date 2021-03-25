import json, boto3, logging, urllib.parse
from pprint import pprint
from botocore.exceptions import ClientError


'''
USAGE
Requesting signed S3 URL for file 2BCBG15.jpg and uploading it to bucket ltd-noooner-dam-core-upload-dev
    curl -X PUT -T 2BCBG15.jpg \
    $(curl -H "Content-Type: application/json" -X POST  https://ijaq4wolyh.execute-api.eu-west-1.amazonaws.com/uploads \
    -d '{"bucket": "ltd-noooner-dam-core-upload-dev", "key": "2BCBG15.jpg"}')
'''


def lambda_handler(event, context):

    pprint(event)

    # Generate a presigned S3 POST URL
    s3_client = boto3.client('s3')
    
    if type(event['body']) == str:
        # make string type body a dict
        payload = json.loads(event['body'])
    else: 
        payload = event['body']

    print('Contents of the payload is ' + str(payload))
    print('Payload type is ' + str(type(payload)))
    bucket_name = payload['bucket']
    object_name = payload['key']

    fields=None
    conditions=None
    expiration=300
    try:
        response = s3_client.generate_presigned_url('put_object',
                                                    Params={'Bucket': bucket_name,
                                                            'Key': object_name},
                                                    ExpiresIn=expiration)
    except ClientError as e:
        logging.error(e)
        return None

    # The response contains the presigned URL
    pprint(response)

    return response
