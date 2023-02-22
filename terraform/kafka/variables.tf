variable json_path {
  type        = string
  default     = "../environments/poc/poc.json"
  description = "Configuration variables for the environment. Set by export TF_VAR_json_path=../environments/poc/poc.json"
}

variable aiven_api_token {
  type        = string
  description = "Aiven API token, see https://docs.aiven.io/docs/platform/howto/create_authentication_token"
}
