output "available_models" {
  description = "Foundation models matching var.model_catalog, keyed by model ID."
  value       = try(module.model_catalog[0].models, null)
}

output "enabled_model_ids" {
  description = "Model IDs with an accepted access agreement."
  value       = try(module.model_access[0].enabled_model_ids, [])
}

output "inference_profiles" {
  description = "Inference profile ARNs by name. Use as modelId."
  value       = { for k, m in module.inference_profile : k => m.arn }
}

output "provisioned_throughputs" {
  description = "Provisioned model ARNs by name. Use as modelId."
  value       = { for k, m in module.provisioned_throughput : k => m.arn }
}

output "guardrails" {
  description = "Guardrail IDs and versions by name."
  value       = { for k, m in module.guardrail : k => { id = m.id, arn = m.arn, version = m.version } }
}

output "invocation_logging" {
  description = "Log destinations, if enabled."
  value = try({
    s3_bucket      = module.invocation_logging[0].s3_bucket
    log_group_name = module.invocation_logging[0].log_group_name
  }, null)
}

output "agents" {
  description = "Agent IDs, alias IDs and role ARNs by name."
  value = {
    for k, m in module.agent : k => {
      agent_id = m.agent_id
      alias_id = m.alias_id
      role_arn = m.role_arn
    }
  }
}

output "mantle_projects" {
  description = "Mantle project IDs and ARNs by name."
  value       = { for k, m in module.mantle_project : k => { project_id = m.project_id, arn = m.arn } }
}
