output "available_models" {
  description = "Models matching the discovery filters."
  value = [
    for m in data.aws_bedrock_foundation_models.available.model_summaries : {
      model_id        = m.model_id
      model_name      = m.model_name
      provider        = m.provider_name
      input           = m.input_modalities
      output          = m.output_modalities
      inference_types = m.inference_types_supported
      customizations  = m.customizations_supported
    }
  ]
}

output "selected_model" {
  description = "Details of the chosen foundation model."
  value = {
    model_id        = data.aws_bedrock_foundation_model.selected.model_id
    model_arn       = data.aws_bedrock_foundation_model.selected.model_arn
    model_name      = data.aws_bedrock_foundation_model.selected.model_name
    provider        = data.aws_bedrock_foundation_model.selected.provider_name
    inference_types = data.aws_bedrock_foundation_model.selected.inference_types_supported
  }
}

output "inference_profile_arn" {
  description = "Use this ARN as the modelId when calling InvokeModel / Converse."
  value       = aws_bedrock_inference_profile.this.arn
}

output "provisioned_model_arn" {
  description = "ARN of the provisioned throughput, if enabled."
  value       = try(aws_bedrock_provisioned_model_throughput.this[0].provisioned_model_arn, null)
}
