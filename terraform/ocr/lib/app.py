from copy import Error
import json, boto3, os, sys, logging
from pprint import pprint
import urllib.parse
from botocore.exceptions import ClientError

IS_OFFLINE = os.environ.get('IS_OFFLINE')

if IS_OFFLINE:
    s3_client = boto3.client(
        's3',
        region_name = 'localhost',
        endpoint_url = 'http://localhost:4566',
        aws_access_key_id = 'whatever',
        aws_secret_access_key = 'whatever'
    )
else:
    s3_client = boto3.client('s3')

def md5sum(image_bytes):
    import hashlib
    checksum = hashlib.md5(image_bytes).hexdigest()
    return checksum

def S3Del(s3_client, file_name, bucket_name):
    '''
    :param s3_client: Boto3 client object
    :param file_name: File to delete
    :param bucket_name: Bucket to delete from
    '''

    try:
        response = s3_client.delete_object(
            Key=file_name, 
            Bucket=bucket_name)
    except ClientError as e:
        logging.error(e)
        return False
    return True    

def S3Get(s3_client, file_name, bucket_name):
    '''
    :param s3_client: Boto3 client object
    :param file_name: File to get
    :param bucket_name: Bucket to get from

    Returns
    ------
    File object on the disk in /tmp, filename format md5sum.ext
    '''

    try:
        response = s3_client.get_object(
            Key=file_name,
            Bucket=bucket_name)

    except ClientError as e:
        logging.error(e)
        return False

    lst_file_ext = file_name.split('.')
    file_ext = lst_file_ext[-1]
    response_body = response['Body'].read() # StreamingBody to bytes
    tmp_file = '/tmp/' + file_name
    with open(tmp_file, "wb") as binary_file: #Write bytes to a file
        binary_file.write(response_body)

    return tmp_file

def lambda_handler(event, context):
    """
    Description
    ----------
    Download original image from S3 bucket based on event information.
    Create thumbnail of the image and write it into THUMBNAIL_BUCKET

    Based on https://auth0.com/blog/image-processing-in-python-with-pillow/#Installation-and-Project-Setup

    Parameters
    ----------
    event: dict, required
        API Gateway Lambda Proxy Input Format

        Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format

    context: object, required
        Lambda Context runtime methods and attributes

        Context doc: https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

    Returns
    ------
    None

    """
    
    try:
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
        print('Received event from bucket ' + bucket + ' for file ' + key)
    except:
        print('OOOPS! Failed to parse event. Here is what was received: ')
        pprint(event)
        return None
    
    try:
        print(f'Attempting to get file {key}')
        original_file = S3Get(s3_client, key, bucket)
        if original_file is False:
            print(f'OOOPS! File {key} not found in the bucket {bucket}. Exit and return None.')
            return None
    except Exception as e:
        print(e)
        print(f'OOOPS! Failed to get file {key} from the bucket {bucket}')
        return None

    # Tidy up file system
    if os.path.exists(original_file):
        file_size = os.path.getsize(original_file)
        print(f'File {key} ({file_size} bytes) successfully received from S3 bucket {bucket}')
        os.remove(original_file)
    else:
        print(f'OOOPS! Could not get the file {key} from bucket {bucket}')

    return None
