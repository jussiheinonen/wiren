locals {
  config  = jsondecode(file(var.json_path))
  common  = local.config.common
  lambda  = local.config.lambda
}