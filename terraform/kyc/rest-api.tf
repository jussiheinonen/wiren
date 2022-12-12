
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
resource "aws_api_gateway_rest_api" "kyc_rest_api" {
  name                = "${local.common.tags.stack_id}-kyc-rest-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  binary_media_types  = [
    "application/json"
  ]
  tags = local.common.tags
}

resource "aws_api_gateway_resource" "kyc_rest_api_resource_object" {
  rest_api_id = aws_api_gateway_rest_api.kyc_rest_api.id
  parent_id   = aws_api_gateway_rest_api.kyc_rest_api.root_resource_id
  path_part   = "get"
}

resource "aws_api_gateway_method" "kyc_rest_api_method_get" { 
  rest_api_id         = aws_api_gateway_rest_api.kyc_rest_api.id
  resource_id         = aws_api_gateway_resource.kyc_rest_api_resource_object.id
  http_method         = "GET"
  authorization       = "NONE"
  api_key_required    = false
  
  request_parameters  = {
    "method.request.path.folder" = true
    "method.request.path.object" = true
  }
  
}



#https://docs.aws.amazon.com/apigateway/latest/api/API_getIntegration.html#API_getIntegration_RequestSyntax
resource "aws_api_gateway_integration" "kyc_rest_api_integration" {
  depends_on                = [aws_api_gateway_method.kyc_rest_api_method_get]
  resource_id               = aws_api_gateway_resource.kyc_rest_api_resource_object.id
  rest_api_id               = aws_api_gateway_rest_api.kyc_rest_api.id
  http_method               = aws_api_gateway_method.kyc_rest_api_method_get.http_method
  integration_http_method   = "GET" 
  type                      = "AWS"
  uri                       = "arn:aws:apigateway:${local.common.tags.region}:s3:path/${aws_s3_bucket.kyc_bucket_outbound.bucket}/kyc.json"
  credentials               = aws_iam_role.kyc_api_gateway_get_from_s3_role.arn
  
  request_parameters = {
    "integration.request.path.bucket" = "method.request.path.folder"
    "integration.request.path.key"    = "method.request.path.object"
  }
  
}

resource "aws_api_gateway_method_response" "Status200" {
  depends_on = [aws_api_gateway_integration.kyc_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.kyc_rest_api.id
  resource_id = aws_api_gateway_resource.kyc_rest_api_resource_object.id
  http_method = aws_api_gateway_method.kyc_rest_api_method_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "Status500" {
  depends_on = [aws_api_gateway_integration.kyc_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.kyc_rest_api.id
  resource_id = aws_api_gateway_resource.kyc_rest_api_resource_object.id
  http_method = aws_api_gateway_method.kyc_rest_api_method_get.http_method
  status_code = "500"
}


resource "aws_api_gateway_integration_response" "IntegrationResponse200" {
  depends_on = [aws_api_gateway_integration.kyc_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.kyc_rest_api.id
  resource_id = aws_api_gateway_resource.kyc_rest_api_resource_object.id
  http_method = aws_api_gateway_method.kyc_rest_api_method_get.http_method
  status_code = aws_api_gateway_method_response.Status200.status_code
  
  response_parameters = {
    "method.response.header.Timestamp"      = "integration.response.header.Date"
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type"   = "'application/json'"
  }

  
}

resource "aws_api_gateway_integration_response" "IntegrationResponse500" {
  depends_on = [aws_api_gateway_integration.kyc_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.kyc_rest_api.id
  resource_id = aws_api_gateway_resource.kyc_rest_api_resource_object.id
  http_method = aws_api_gateway_method.kyc_rest_api_method_get.http_method
  status_code = aws_api_gateway_method_response.Status500.status_code

  selection_pattern = "5\\d{2}"
}

resource "aws_api_gateway_deployment" "kyc_rest_api_deployment" {
  depends_on  = [aws_api_gateway_integration.kyc_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.kyc_rest_api.id
  stage_name  = "kyc"

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.kyc_rest_api.id,
      #aws_api_gateway_resource.kyc_rest_api_resource_folder.id,
      aws_api_gateway_resource.kyc_rest_api_resource_object.id,
      aws_api_gateway_method.kyc_rest_api_method_get.id,
      aws_api_gateway_integration.kyc_rest_api_integration.id,
      aws_api_gateway_method_response.Status200.id,
      aws_api_gateway_method_response.Status500.id,
      aws_api_gateway_integration_response.IntegrationResponse200.id,
      aws_api_gateway_integration_response.IntegrationResponse500.id
    ]))
  }
}
