
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
resource "aws_api_gateway_rest_api" "ocr_rest_api" {
  name                = "${local.common.tags.service_id}-rest-api"
  binary_media_types  = [
    "image/jpeg",
    "image/png" 
  ]
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
  authorization = "AWS_IAM"  
}


#https://docs.aws.amazon.com/apigateway/latest/api/API_PutIntegration.html#API_PutIntegration_RequestSyntax
resource "aws_api_gateway_integration" "ocr_rest_api_integration" {
  resource_id               = aws_api_gateway_resource.ocr_rest_api_resource_object.id
  rest_api_id               = aws_api_gateway_rest_api.ocr_rest_api.id
  http_method               = aws_api_gateway_method.ocr_rest_api_method_put.http_method
  integration_http_method   = "PUT" 
  type                      = "AWS"
  uri                       = "arn:aws:apigateway:${local.common.tags.region}:s3:path/{bucket}/{key}"
  credentials               = aws_iam_role.ocr_api_gateway_upload_to_s3_role.arn

  request_parameters = {
    "integration.request.path.folder"  = "'method.request.path.folder'"
    "integration.request.path.object"  = "'method.request.path.object'"
  }
}

resource "aws_api_gateway_deployment" "ocr_rest_api_deployment" {
  depends_on  = [aws_api_gateway_integration.ocr_rest_api_integration]
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
  stage_name  = "ocr"
}
