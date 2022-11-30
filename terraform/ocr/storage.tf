# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "ocr_bucket_inbound" {
  bucket = "${local.common.tags.service_id}-bucket-inbound"

  #tags = local.common.tags 
}

resource "aws_s3_bucket_acl" "ocr_bucket_inbound_acl" {
  bucket = aws_s3_bucket.ocr_bucket_inbound.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ocr_bucket_inbound_enc" {
  bucket = aws_s3_bucket.ocr_bucket_inbound.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}