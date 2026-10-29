data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  source_arn = "arn:aws:bedrock:${data.aws_region.current.region}:${local.account_id}:*"
}

# ----- S3 -----

resource "aws_s3_bucket" "this" {
  count = var.s3_enabled ? 1 : 0

  bucket_prefix = "${var.name_prefix}-"
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.s3_enabled ? 1 : 0

  bucket                  = aws_s3_bucket.this[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  count = var.s3_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "bedrock.amazonaws.com" }
      Action    = "s3:PutObject"
      Resource  = "${aws_s3_bucket.this[0].arn}/*"
      Condition = {
        StringEquals = { "aws:SourceAccount" = local.account_id }
        ArnLike      = { "aws:SourceArn" = local.source_arn }
      }
    }]
  })
}

# ----- CloudWatch -----

resource "aws_cloudwatch_log_group" "this" {
  count = var.cloudwatch_enabled ? 1 : 0

  name              = "/aws/bedrock/${var.name_prefix}"
  retention_in_days = var.cloudwatch_retention_days
  tags              = var.tags
}

resource "aws_iam_role" "cloudwatch" {
  count = var.cloudwatch_enabled ? 1 : 0

  name_prefix = "${var.name_prefix}-"
  tags        = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "bedrock.amazonaws.com" }
      Action    = "sts:AssumeRole"
      Condition = {
        StringEquals = { "aws:SourceAccount" = local.account_id }
        ArnLike      = { "aws:SourceArn" = local.source_arn }
      }
    }]
  })
}

resource "aws_iam_role_policy" "cloudwatch" {
  count = var.cloudwatch_enabled ? 1 : 0

  role = aws_iam_role.cloudwatch[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
      Resource = "${aws_cloudwatch_log_group.this[0].arn}:*"
    }]
  })
}

# ----- Account-level logging config (one per region) -----

resource "aws_bedrock_model_invocation_logging_configuration" "this" {
  logging_config {
    text_data_delivery_enabled      = var.log_text
    image_data_delivery_enabled     = var.log_images
    embedding_data_delivery_enabled = var.log_embeddings
    video_data_delivery_enabled     = var.log_video

    dynamic "s3_config" {
      for_each = var.s3_enabled ? [1] : []
      content {
        bucket_name = aws_s3_bucket.this[0].id
        key_prefix  = "bedrock"
      }
    }

    dynamic "cloudwatch_config" {
      for_each = var.cloudwatch_enabled ? [1] : []
      content {
        log_group_name = aws_cloudwatch_log_group.this[0].name
        role_arn       = aws_iam_role.cloudwatch[0].arn
      }
    }
  }

  depends_on = [aws_s3_bucket_policy.this, aws_iam_role_policy.cloudwatch]
}
