# Terraform scripts / modules

## Development runtime

### Starting the container

```
docker run -v "${HOME}/.aws":/root/.aws -v $(pwd):/repo -it terraform_aws:latest
```

### Set the environment

```
export TF_VAR_json_path=../environments/default/default.json
```

### Running Terraform

```
terraform init
terraform plan
terraformm apply
```




