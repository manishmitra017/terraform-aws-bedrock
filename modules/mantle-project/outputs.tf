output "project_id" {
  description = "Mantle project ID."
  value       = awscc_bedrockmantle_project.this.project_id
}

output "arn" {
  description = "Mantle project ARN."
  value       = awscc_bedrockmantle_project.this.arn
}
