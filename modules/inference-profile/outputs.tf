output "arn" {
  description = "Profile ARN. Pass as modelId to InvokeModel / Converse."
  value       = aws_bedrock_inference_profile.this.arn
}

output "id" {
  description = "Profile ID."
  value       = aws_bedrock_inference_profile.this.id
}
