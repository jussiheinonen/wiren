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
        Resource = [
          aws_s3_bucket.ocr_bucket_inbound.arn,
          "${aws_s3_bucket.ocr_bucket_inbound.arn}/*"
        ]
      },
    ]
  })
}

/*
resource "aws_iam_user" "demo_user" {
  name          = "demo-user"
  path          = "/"
  force_destroy = true
  tags          = local.common.tags
}

resource "aws_iam_access_key" "demo_access_key" {
  user = aws_iam_user.demo_user.name
}

resource "aws_iam_user_policy" "ocr_demo_user_upload_to_s3_policy" {
  name = "${local.common.tags.service_id}-demo-user-upload-to-s3-policy"
  user = aws_iam_user.demo_user.name

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
        Resource = [
          aws_s3_bucket.ocr_bucket_inbound.arn,
          "${aws_s3_bucket.ocr_bucket_inbound.arn}/*"
        ]
      },
    ]
  })
}
*/