# Based on https://aws.amazon.com/premiumsupport/knowledge-center/api-gateway-upload-image-s3/
resource "aws_iam_role" "ocr_api_gateway_upload_to_s3_role" {
  name = "${local.common.tags.service_id}-api-gateway-upload-to-s3-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })

  tags = local.common.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
resource "aws_iam_role_policy" "ocr_api_gateway_upload_to_s3_policy" {
  name = "${local.common.tags.service_id}-api-gateway-upload-to-s3-policy"
  role = aws_iam_role.ocr_api_gateway_upload_to_s3_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.ocr_bucket_inbound.arn}"
      },
    ]
  })
}

# Attach S3 Access Policy to the API Gateway Role
# https://github.com/hashicorp/terraform-provider-aws/blob/main/examples/s3-api-gateway-integration/main.tf
#resource "aws_iam_role_policy_attachment" "ocr_s3_policy_attach" {
#  role       = aws_iam_role.ocr_api_gateway_upload_to_s3_role.name
#  policy_arn = aws_iam_role_policy.ocr_api_gateway_upload_to_s3_policy.arn
#}