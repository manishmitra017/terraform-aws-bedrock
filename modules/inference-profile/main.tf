data "aws_bedrock_foundation_model" "this" {
  count    = var.source_type == "foundation-model" ? 1 : 0
  model_id = var.model_id
}

data "aws_bedrock_inference_profile" "this" {
  count                = var.source_type == "inference-profile" ? 1 : 0
  inference_profile_id = var.model_id
}

resource "aws_bedrock_inference_profile" "this" {
  name        = var.name
  description = coalesce(var.description, "Application inference profile for ${var.model_id}")

  model_source {
    copy_from = (
      var.source_type == "foundation-model"
      ? data.aws_bedrock_foundation_model.this[0].model_arn
      : data.aws_bedrock_inference_profile.this[0].inference_profile_arn
    )
  }

  tags = var.tags
}
