
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
resource "aws_api_gateway_rest_api" "ocr_rest_api" {
  name = "${local.common.tags.service_id}-rest-api"
}

resource "aws_api_gateway_resource" "ocr_rest_api_resource_folder" {
  parent_id   = aws_api_gateway_rest_api.ocr_rest_api.root_resource_id
  path_part   = "{folder}"
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
}

resource "aws_api_gateway_resource" "ocr_rest_api_resource_object" {
  parent_id   = aws_api_gateway_rest_api.ocr_rest_api.root_resource_id
  path_part   = "{object}"
  rest_api_id = aws_api_gateway_rest_api.ocr_rest_api.id
}


resource "aws_api_gateway_method" "ocr_rest_api_method_put" {
  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.ocr_rest_api_resource_object.id
  rest_api_id   = aws_api_gateway_rest_api.ocr_rest_api.id
}

/*
resource "aws_api_gateway_integration" "ocr_rest_api_integration" {
  http_method               = aws_api_gateway_method.ocr_rest_api_method_put.http_method
  resource_id               = aws_api_gateway_resource.ocr_rest_api_resource_object.id
  rest_api_id               = aws_api_gateway_rest_api.ocr_rest_api.id
  type                      = "HTTP_PROXY"
  integration_http_method   = "PUT"
  uri                       = aws_s3_bucket.ocr_bucket_inbound.arn
  
}
*/