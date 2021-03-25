# Run: python3 app-invoke.py

from app import lambda_handler
    
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

def mockAPITrigger(bucket, key):
    event = dict(
        {
            "body": {"bucket": bucket, "key": key }
        }
    )
    return event

event = mockAPITrigger('ltd-noooner-dam-core-upload-dev', '2BCBG15_over_medium.jpg')

lambda_handler(event, None)