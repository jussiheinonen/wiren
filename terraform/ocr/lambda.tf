provider "archive" {}

data "archive_file" "ocr_function" {
  type             = "zip"
  source_file      = "${path.module}/${local.ocr.lambda.library_path}"
  output_file_mode = "0666"
  output_path      = "${path.module}/bin/app.py.zip"
}

resource "aws_lambda_function" "ocr_lambda_function" {
  function_name                  = "${local.common.tags.service_id}-lambda-function"
  filename                       = "${path.module}/bin/app.py.zip"
  source_code_hash               = filebase64sha256("${path.module}/bin/app.py.zip")
  role                           = aws_iam_role.ocr_lambda_role.arn
  handler                        = local.ocr.lambda.handler
  runtime                        = local.ocr.lambda.runtime
  tags                           = local.common.tags
}

resource "aws_lambda_permission" "ocr_allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ocr_lambda_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.ocr_bucket_inbound.arn
}

resource "aws_s3_bucket_notification" "ocr_bucket_notification" {
  bucket = aws_s3_bucket.ocr_bucket_inbound.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.ocr_lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.ocr_allow_bucket]
}