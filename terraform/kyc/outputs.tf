output "stack_id" {
    description = "Stack Identification"
    value       = local.common.tags.stack_id
}

output "aws_region" {
    description = "AWS region to deploy to"
    value       = local.common.tags.region
}

output "rest_api_endpoint" {
    description = "Public endpoint for REST API "
    value       = aws_api_gateway_deployment.kyc_rest_api_deployment.invoke_url
}

output "rest_api_upload_example_command" {
    description = "Curl example command"
    value       = "curl ${aws_api_gateway_deployment.kyc_rest_api_deployment.invoke_url}/${aws_api_gateway_resource.kyc_rest_api_resource_object.path_part}"
}