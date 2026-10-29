output "id" {
  description = "Guardrail ID."
  value       = aws_bedrock_guardrail.this.guardrail_id
}

output "arn" {
  description = "Guardrail ARN."
  value       = aws_bedrock_guardrail.this.guardrail_arn
}

output "version" {
  description = "Published version, or DRAFT if create_version = false."
  value       = try(aws_bedrock_guardrail_version.this[0].version, "DRAFT")
}
