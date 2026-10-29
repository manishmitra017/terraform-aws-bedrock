data "aws_bedrock_foundation_model" "this" {
  count    = var.model_arn == null ? 1 : 0
  model_id = var.model_id
}

# WARNING: billed per hour per model unit, and commitments cannot be cancelled.
resource "aws_bedrock_provisioned_model_throughput" "this" {
  provisioned_model_name = var.name
  model_arn              = coalesce(var.model_arn, try(data.aws_bedrock_foundation_model.this[0].model_arn, null))
  model_units            = var.model_units
  commitment_duration    = var.commitment_duration
  tags                   = var.tags
}
