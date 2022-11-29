# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "ocr_bucket_inbound" {
  bucket = "ocr-bucket-inbound"

  tags = local.common.tags 
}

resource "aws_s3_bucket_acl" "ocr_bucket_inbound_acl" {
  bucket = aws_s3_bucket.ocr_bucket_inbound.id
  acl    = "private"
}