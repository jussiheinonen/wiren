output "service_id" {
    description = "Service Identification"
    value       = local.common.tags.service_id
}

output "aws_region" {
    description = "AWS region to deploy to"
    value       = local.common.tags.region
}