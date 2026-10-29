output "enabled_model_ids" {
  description = "Model IDs with an accepted agreement."
  value       = keys(aws_bedrock_foundation_model_agreement.this)
}
