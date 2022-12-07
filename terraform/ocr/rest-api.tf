
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
resource "aws_api_gateway_rest_api" "ocr_rest_api" {
  name                = "${local.common.tags.service_id}-rest-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  binary_media_types  = [
    "image/jpeg",
    "image/png" 
  ]
  tags = local.common.tags
}

resource "aws_api_gateway_resource" "ocr_rest_api_resource_folder" {
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
  parent_id   = aws_api_gateway_rest_api.ocr_rest_api.root_resource_id
  path_part   = "{folder}"
}

resource "aws_api_gateway_resource" "ocr_rest_api_resource_object" {
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
  parent_id   = aws_api_gateway_resource.ocr_rest_api_resource_folder.id
  path_part   = "{object}"
}


resource "aws_api_gateway_method" "ocr_rest_api_method_put" { 
  rest_api_id   = aws_api_gateway_rest_api.ocr_rest_api.id
  resource_id   = aws_api_gateway_resource.ocr_rest_api_resource_object.id
  http_method   = "PUT"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.folder" = true
    "method.request.path.object" = true
  }
}


#https://docs.aws.amazon.com/apigateway/latest/api/API_PutIntegration.html#API_PutIntegration_RequestSyntax
resource "aws_api_gateway_integration" "ocr_rest_api_integration" {
  depends_on                = [aws_api_gateway_method.ocr_rest_api_method_put]
  resource_id               = aws_api_gateway_resource.ocr_rest_api_resource_object.id
  rest_api_id               = aws_api_gateway_rest_api.ocr_rest_api.id
  http_method               = aws_api_gateway_method.ocr_rest_api_method_put.http_method
  integration_http_method   = "PUT" 
  type                      = "AWS"
  uri                       = "arn:aws:apigateway:${local.common.tags.region}:s3:path/{bucket}/{key}"
  credentials               = aws_iam_role.ocr_api_gateway_upload_to_s3_role.arn

  request_parameters = {
    "integration.request.path.bucket" = "method.request.path.folder"
    "integration.request.path.key"    = "method.request.path.object"
  }
}

resource "aws_api_gateway_method_response" "Status200" {
  depends_on = [aws_api_gateway_integration.ocr_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
  resource_id = aws_api_gateway_resource.ocr_rest_api_resource_object.id
  http_method = aws_api_gateway_method.ocr_rest_api_method_put.http_method
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
  depends_on = [aws_api_gateway_integration.ocr_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
  resource_id = aws_api_gateway_resource.ocr_rest_api_resource_object.id
  http_method = aws_api_gateway_method.ocr_rest_api_method_put.http_method
  status_code = "500"
}


resource "aws_api_gateway_integration_response" "IntegrationResponse200" {
  depends_on = [aws_api_gateway_integration.ocr_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
  resource_id = aws_api_gateway_resource.ocr_rest_api_resource_object.id
  http_method = aws_api_gateway_method.ocr_rest_api_method_put.http_method
  status_code = aws_api_gateway_method_response.Status200.status_code

  response_parameters = {
    "method.response.header.Timestamp"      = "integration.response.header.Date"
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type"   = "integration.response.header.Content-Type"
  }
}

resource "aws_api_gateway_integration_response" "IntegrationResponse500" {
  depends_on = [aws_api_gateway_integration.ocr_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
  resource_id = aws_api_gateway_resource.ocr_rest_api_resource_object.id
  http_method = aws_api_gateway_method.ocr_rest_api_method_put.http_method
  status_code = aws_api_gateway_method_response.Status500.status_code

  selection_pattern = "5\\d{2}"
}

resource "aws_api_gateway_deployment" "ocr_rest_api_deployment" {
  depends_on  = [aws_api_gateway_integration.ocr_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
  stage_name  = "ocr"

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.ocr_rest_api.id,
      aws_api_gateway_resource.ocr_rest_api_resource_folder.id,
      aws_api_gateway_resource.ocr_rest_api_resource_object.id,
      aws_api_gateway_method.ocr_rest_api_method_put.id,
      aws_api_gateway_integration.ocr_rest_api_integration.id,
      aws_api_gateway_method_response.Status200.id,
      aws_api_gateway_method_response.Status500.id,
      aws_api_gateway_integration_response.IntegrationResponse200.id,
      aws_api_gateway_integration_response.IntegrationResponse500.id
    ]))
  }
}
