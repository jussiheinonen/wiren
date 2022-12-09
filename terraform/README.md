# Terraform scripts / modules

## Development runtime

### Localstack

#### Updating the image

`docker pull localstack/localstack`

#### Starting the container

`docker run --rm -p 4566:4566 -p 4571:4571 localstack/localstack`

### Starting the container

#### without credentials (for localstack)

`docker run -v $(pwd):/repo --net=host -it terraform_aws:latest`

#### with AWS credentials
`docker run -v "${HOME}/.aws":/root/.aws -v $(pwd):/repo -it terraform_aws:latest`

#### Set the environment

`export TF_VAR_json_path=../environments/default/default.json`

#### Running Terraform

```
terraform init
terraform plan
terraformm apply
```

#### Copying file to the bucket

aws s3 cp ocr/airplane.png s3://ocr-inbound --endpoint-url http://localhost:4566








