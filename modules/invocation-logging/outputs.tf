output "s3_bucket" {
  description = "Log bucket name, if enabled."
  value       = try(aws_s3_bucket.this[0].id, null)
}

output "log_group_name" {
  description = "CloudWatch log group, if enabled."
  value       = try(aws_cloudwatch_log_group.this[0].name, null)
}
