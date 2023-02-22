locals {
  config  = jsondecode(file(var.json_path))
  common  = local.config.common
  kafka   = local.config.kafka
}