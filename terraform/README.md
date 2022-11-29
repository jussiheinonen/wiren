# Terraform scripts / modules

## Bootstrap

### Terraform binary
```
wget https://releases.hashicorp.com/terraform/1.3.5/terraform_1.3.5_linux_amd64.zip
unzip terraform_1.3.5_linux_amd64.zip
mv terraform /usr/local/bin/
```

### Terraform environment

```
export TF_VAR_json_path=../environments/default/default.json
```




