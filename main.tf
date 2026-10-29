module "model_catalog" {
  source = "./modules/model-catalog"
  count  = var.model_catalog == null ? 0 : 1

  provider_name      = var.model_catalog.provider_name
  output_modality    = var.model_catalog.output_modality
  inference_type     = var.model_catalog.inference_type
  customization_type = var.model_catalog.customization_type
}

module "model_access" {
  source = "./modules/model-access"
  count  = var.model_access == null ? 0 : 1

  model_ids          = var.model_access.model_ids
  anthropic_use_case = var.model_access.anthropic_use_case
}

module "inference_profile" {
  source   = "./modules/inference-profile"
  for_each = var.inference_profiles

  name        = each.key
  model_id    = each.value.model_id
  source_type = each.value.source_type
  description = each.value.description
  tags        = var.tags

  depends_on = [module.model_access]
}

module "provisioned_throughput" {
  source   = "./modules/provisioned-throughput"
  for_each = var.provisioned_throughputs

  name                = each.key
  model_id            = each.value.model_id
  model_arn           = each.value.model_arn
  model_units         = each.value.model_units
  commitment_duration = each.value.commitment_duration
  tags                = var.tags

  depends_on = [module.model_access]
}

module "guardrail" {
  source   = "./modules/guardrail"
  for_each = var.guardrails

  name                   = each.key
  description            = each.value.description
  blocked_input_message  = each.value.blocked_input_message
  blocked_output_message = each.value.blocked_output_message
  content_filters        = each.value.content_filters
  denied_topics          = each.value.denied_topics
  pii_entities           = each.value.pii_entities
  regexes                = each.value.regexes
  blocked_words          = each.value.blocked_words
  block_profanity        = each.value.block_profanity
  grounding_threshold    = each.value.grounding_threshold
  create_version         = each.value.create_version
  kms_key_arn            = each.value.kms_key_arn
  tags                   = var.tags
}

module "invocation_logging" {
  source = "./modules/invocation-logging"
  count  = var.invocation_logging == null ? 0 : 1

  name_prefix               = var.invocation_logging.name_prefix
  s3_enabled                = var.invocation_logging.s3_enabled
  cloudwatch_enabled        = var.invocation_logging.cloudwatch_enabled
  cloudwatch_retention_days = var.invocation_logging.cloudwatch_retention_days
  log_text                  = var.invocation_logging.log_text
  log_images                = var.invocation_logging.log_images
  log_embeddings            = var.invocation_logging.log_embeddings
  log_video                 = var.invocation_logging.log_video
  force_destroy             = var.invocation_logging.force_destroy
  tags                      = var.tags
}

module "agent" {
  source   = "./modules/agent"
  for_each = var.agents

  name                     = each.key
  model_id                 = each.value.model_id
  instruction              = each.value.instruction
  description              = each.value.description
  idle_session_ttl_seconds = each.value.idle_session_ttl_seconds
  alias_name               = each.value.alias_name
  tags                     = var.tags

  guardrail = each.value.guardrail_key == null ? null : {
    id      = module.guardrail[each.value.guardrail_key].id
    version = module.guardrail[each.value.guardrail_key].version
  }

  depends_on = [module.model_access]
}

module "mantle_project" {
  source   = "./modules/mantle-project"
  for_each = var.mantle_projects

  name = each.key
  tags = merge(var.tags, each.value.tags)
}
