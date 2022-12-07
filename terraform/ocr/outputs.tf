output "service_id" {
    description = "Service Identification"
    value       = local.common.tags.service_id
}

output "aws_region" {
    description = "AWS region to deploy to"
    value       = local.common.tags.region
}

output "rest_api_endpoint" {
    description = "Public endpoint for REST API "
    value       = aws_api_gateway_deployment.ocr_rest_api_deployment.invoke_url
}

output "rest_api_upload_example_command" {
    description = "Curl example command"
    value       = "curl -X PUT -T file.jpg ${aws_api_gateway_deployment.ocr_rest_api_deployment.invoke_url}/${aws_s3_bucket.ocr_bucket_inbound.bucket}/file.jpg"
}