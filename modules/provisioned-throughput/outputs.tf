output "arn" {
  description = "Provisioned model ARN. Pass as modelId when invoking."
  value       = aws_bedrock_provisioned_model_throughput.this.provisioned_model_arn
}
