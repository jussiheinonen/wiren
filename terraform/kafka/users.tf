resource "aiven_kafka_user" "for_each" {
  for_each     = local.kafka.users
  service_name = local.kafka.service_name
  project      = local.kafka.project_name
  username     = local.kafka.users[each.key].username
}