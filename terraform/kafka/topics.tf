# Kafka topic
resource "aiven_kafka_topic" "for_each" {
  for_each     = local.kafka.topics
  project      = local.kafka.project_name
  service_name = local.kafka.service_name
  topic_name   = local.kafka.topics[each.key].name
  partitions   = local.kafka.topics[each.key].partitions
  replication  = local.kafka.topics[each.key].replication
  depends_on = [
    aiven_kafka.this
  ]
}