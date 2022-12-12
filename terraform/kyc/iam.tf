# Based on https://aws.amazon.com/premiumsupport/knowledge-center/api-gateway-upload-image-s3/
resource "aws_iam_role" "kyc_api_gateway_get_from_s3_role" {
  name = "${local.common.tags.stack_id}-api-gateway-get-from-s3-role"

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
resource "aws_iam_role_policy" "kyc_api_gateway_get_from_s3_policy" {
  name = "${local.common.tags.stack_id}-api-gateway-get-from-s3-policy"
  role = aws_iam_role.kyc_api_gateway_get_from_s3_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.kyc_bucket_outbound.arn,
          "${aws_s3_bucket.kyc_bucket_outbound.arn}/*"
        ]
      },
    ]
  })
}
