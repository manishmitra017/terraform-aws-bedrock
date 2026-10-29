# 1. Discover models available in the region.
data "aws_bedrock_foundation_models" "available" {
  by_provider        = var.filter_provider
  by_output_modality = var.filter_output_modality
  by_inference_type  = var.filter_inference_type
}

# 2. Look up the specific model you chose.
data "aws_bedrock_foundation_model" "selected" {
  model_id = var.model_id
}

data "aws_bedrock_inference_profile" "system" {
  count                = var.system_inference_profile_id == null ? 0 : 1
  inference_profile_id = var.system_inference_profile_id
}

locals {
  source_arn = (
    var.system_inference_profile_id == null
    ? data.aws_bedrock_foundation_model.selected.model_arn
    : data.aws_bedrock_inference_profile.system[0].inference_profile_arn
  )
}

# 3. Instantiate: your own application inference profile for the model.
resource "aws_bedrock_inference_profile" "this" {
  name        = var.name
  description = "Application inference profile for ${var.model_id}"

  model_source {
    copy_from = local.source_arn
  }

  tags = var.tags
}

# 4. Optional: dedicated provisioned throughput.
resource "aws_bedrock_provisioned_model_throughput" "this" {
  count = var.enable_provisioned_throughput ? 1 : 0

  provisioned_model_name = "${var.name}-provisioned"
  model_arn              = data.aws_bedrock_foundation_model.selected.model_arn
  model_units            = var.provisioned_model_units
  commitment_duration    = var.provisioned_commitment_duration

  tags = var.tags
}
