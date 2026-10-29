output "agent_id" {
  description = "Agent ID."
  value       = aws_bedrockagent_agent.this.agent_id
}

output "agent_arn" {
  description = "Agent ARN."
  value       = aws_bedrockagent_agent.this.agent_arn
}

output "alias_id" {
  description = "Alias ID, if created. Use with agent_id to call InvokeAgent."
  value       = try(aws_bedrockagent_agent_alias.this[0].agent_alias_id, null)
}

output "role_arn" {
  description = "IAM role the agent runs as. Attach extra policies here for action groups."
  value       = aws_iam_role.this.arn
}
