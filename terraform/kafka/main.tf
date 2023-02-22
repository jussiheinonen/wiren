terraform {
  required_providers {
    aiven = {
      source  = "aiven/aiven"
      version = "~> 3.12.0"
    }
  }
 
  required_version = ">= 1.3.5"

}    

provider "aiven" {
  api_token = var.aiven_api_token
}

# Kafka service
resource "aiven_kafka" "this" {
  project                 = local.kafka.project_name
  cloud_name              = local.kafka.cloud_name
  plan                    = local.kafka.plan
  service_name            = local.kafka.service_name
  maintenance_window_dow  = local.kafka.maintenance.day_of_week
  maintenance_window_time = local.kafka.maintenance.time_of_day
  kafka_user_config {
    kafka_connect         = local.kafka.user_config.connect_enable
    kafka_rest            = local.kafka.user_config.rest_enable
    kafka_version         = local.kafka.user_config.kafka_version
    kafka {
      group_max_session_timeout_ms = local.kafka.user_config.group_max_timeout_ms
      log_retention_bytes          = local.kafka.user_config.log_retention_bytes
    }
  }
}
