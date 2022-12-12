# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "kyc_bucket_outbound" {
  bucket = "${local.common.tags.stack_id}-kyc-bucket-outbound"
  tags = local.common.tags 
}

resource "aws_s3_bucket_acl" "kyc_bucket_outbound_acl" {
  bucket = aws_s3_bucket.kyc_bucket_outbound.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kyc_bucket_outbound_enc" {
  bucket = aws_s3_bucket.kyc_bucket_outbound.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_object" "kyc_bucket_outbound_object" {
  bucket  = aws_s3_bucket.kyc_bucket_outbound.id
  key     = "kyc.json"
  content = jsonencode({
    "description": local.kyc.verification_description,
    "criteria": {
      "residence": local.kyc.verification.residence,
      "address": local.kyc.verification.address,
      "bills": local.kyc.verification.bills,
      "identity": local.kyc.verification.identity
    }
  })
}