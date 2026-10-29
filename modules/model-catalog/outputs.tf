output "models" {
  description = "Models matching the filters, keyed by model ID."
  value = {
    for m in data.aws_bedrock_foundation_models.this.model_summaries : m.model_id => {
      name            = m.model_name
      arn             = m.model_arn
      provider        = m.provider_name
      input           = m.input_modalities
      output          = m.output_modalities
      inference_types = m.inference_types_supported
      customizations  = m.customizations_supported
      streaming       = m.response_streaming_supported
    }
  }
}

output "model_ids" {
  description = "Sorted list of matching model IDs."
  value       = sort([for m in data.aws_bedrock_foundation_models.this.model_summaries : m.model_id])
}
