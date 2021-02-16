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
 Dynamodb Local Started, Visit: http://localhost:8000/shell
 Serverless: Using Python specified in "runtime": python3.8
 * Running on http://localhost:5000/ (Press CTRL+C to quit)
 * Restarting with stat
Serverless: DynamoDB - created table users-table-dev
 * Debugger is active!
 * Debugger PIN: 549-767-379
 ```
NOTE: When not seeing the line `Serverless: DynamoDB - created table users-table-dev` reported by DynamoDB at start up, it is likely that it has crashed. See TODO block in [Dockerfile](https://github.com/jussiheinonen/wiren/blob/master/Dockerfile) for a workaround.

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

# Maintainer
Jussi Heinonen

[LinkedIn](https://linkedin.com/in/jussiheinonen/)  [Twitter](https://twitter.com/jussihei/)

# Credits & ThankU's

* Alex DeBrie for [excellent blog post](https://www.serverless.com/blog/flask-python-rest-api-serverless-lambda-dynamodb) about serverless REST API
* [DILLINGER](https://dillinger.io/) markdown editor used to create this very README