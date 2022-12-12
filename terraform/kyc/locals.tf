locals {
  config  = jsondecode(file(var.json_path))
  common  = local.config.common
  kyc     = local.config.kyc
}