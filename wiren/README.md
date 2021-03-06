# Wiren
Local development environment with Python3.8, Nodejs and Serverless runtimes

# Benefits

 * Fast feedback loop speeds up development process 
 * Developing in secure sandbox environment
 * Avoid cluttering the main operating environment with tools and modules that are only used for the app
 * Later, use local development environment for production workloads on public cloud infrastructure (ECS, Kubernetes)

# Usage

### Building docker image
`sudo docker build -t wiren:alpine ./$(dirname $0)`
See [Dockerfile](https://github.com/jussiheinonen/wiren/blob/master/Dockerfile) for more build options

### Starting docker container
`sudo docker run -v $(pwd)/wiren:/usr/app/wiren --net=host -it wiren:alpine`

 Console will show the following events when successfully started
 ```
 Serverless: Using Python specified in "runtime": python3.8
 * Running on http://localhost:5000/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 549-767-379
 ```

### End-to-end testing
You can test the functionality by creating a user and retrieving user details using curl command  line utility

#### Creating user
```
$ curl -H "Content-Type: application/json" -X POST http://localhost:5000/users -d '{"userId": "jussihei", "name": "Jussi Heinonen"}'
{
  "name": "Jussi Heinonen", 
  "userId": "jussihei"
}
```
#### Get user details
```
$ curl -H "Content-Type: application/json" -X GET http://localhost:5000/users/jussihei
{
  "name": "Jussi Heinonen", 
  "userId": "jussihei"
}
```

### Command line actions

#### Create table
```
aws dynamodb create-table \
    --table-name users-table-dev \
    --attribute-definitions AttributeName=userId,AttributeType=S \
    --key-schema AttributeName=userId,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --endpoint-url http://localhost:8000
```

#### List tables
```
$ aws dynamodb list-tables --endpoint-url http://localhost:8000
{
    "TableNames": [
        "users-table-dev"
    ]
}
```

#### Query user 
```
$ aws dynamodb query \
    --table-name users-table-dev \
    --key-condition-expression "userId = :name" \
    --expression-attribute-values  '{":name":{"S":"jussihei"}}' \
    --endpoint-url http://localhost:8000
{
    "Items": [
        {
            "name": {
                "S": "Jussi Heinonen"
            },
            "userId": {
                "S": "jussihei"
            }
        }
    ],
    "Count": 1,
    "ScannedCount": 1,
    "ConsumedCapacity": null
}

```

# Serverless Application Model (SAM)

```
#Step 1 - Download a sample application
sam init

#Step 2 - Build your application
cd sam-app
sam build

#Step 3 - Deploy your application
sam deploy --guided

#Step 4 - Whack the stack
aws cloudformation delete-stack --stack-name sam-app --region region
```

# Maintainer
Jussi Heinonen

[LinkedIn](https://linkedin.com/in/jussiheinonen/)  [Twitter](https://twitter.com/jussihei/)

# Credits & ThankU's

* Alex DeBrie for [excellent blog post](https://www.serverless.com/blog/flask-python-rest-api-serverless-lambda-dynamodb) about serverless REST API
* [DILLINGER](https://dillinger.io/) markdown editor used to create this very README