# Every service is off by default. Set a variable to turn that service on.

variable "tags" {
  description = "Tags applied to every resource that supports them."
  type        = map(string)
  default     = {}
}

# ----- Discovery -----

variable "model_catalog" {
  description = "List available foundation models. null = skip. Filters are optional."
  type = object({
    provider_name      = optional(string)
    output_modality    = optional(string)
    inference_type     = optional(string)
    customization_type = optional(string)
  })
  default = null
}

# ----- Model access -----

variable "model_access" {
  description = "Enable access to models (Marketplace agreements and the one-time Anthropic form). null = skip."
  type = object({
    model_ids = optional(set(string), [])
    anthropic_use_case = optional(object({
      company_name    = string
      company_website = string
      intended_users  = string
      industry        = string
      use_cases       = string
    }))
  })
  default = null
}

# ----- Inference -----

variable "inference_profiles" {
  description = "Application inference profiles, keyed by profile name."
  type = map(object({
    model_id    = string
    source_type = optional(string, "foundation-model")
    description = optional(string)
  }))
  default = {}
}

variable "provisioned_throughputs" {
  description = "Provisioned throughput, keyed by name. EXPENSIVE: billed hourly; commitments can't be cancelled."
  type = map(object({
    model_id            = optional(string)
    model_arn           = optional(string)
    model_units         = optional(number, 1)
    commitment_duration = optional(string)
  }))
  default = {}
}

# ----- Safety -----

variable "guardrails" {
  description = "Guardrails, keyed by name. Omitted fields use the guardrail module defaults."
  type = map(object({
    description            = optional(string)
    blocked_input_message  = optional(string)
    blocked_output_message = optional(string)
    content_filters = optional(map(object({
      input_strength  = string
      output_strength = string
    })))
    denied_topics = optional(map(object({
      definition = string
      examples   = optional(list(string), [])
    })))
    pii_entities = optional(map(string))
    regexes = optional(map(object({
      pattern     = string
      action      = optional(string, "BLOCK")
      description = optional(string)
    })))
    blocked_words       = optional(list(string))
    block_profanity     = optional(bool)
    grounding_threshold = optional(number)
    create_version      = optional(bool)
    kms_key_arn         = optional(string)
  }))
  default = {}
}

# ----- Observability -----

variable "invocation_logging" {
  description = "Account-level model invocation logging for this region. null = skip."
  type = object({
    name_prefix               = optional(string, "bedrock-invocation-logs")
    s3_enabled                = optional(bool, true)
    cloudwatch_enabled        = optional(bool, false)
    cloudwatch_retention_days = optional(number, 30)
    log_text                  = optional(bool, true)
    log_images                = optional(bool, false)
    log_embeddings            = optional(bool, false)
    log_video                 = optional(bool, false)
    force_destroy             = optional(bool, false)
  })
  default = null
}

# ----- Agents -----

variable "agents" {
  description = "Bedrock Agents, keyed by name. guardrail_key refers to an entry in var.guardrails."
  type = map(object({
    model_id                 = string
    instruction              = string
    description              = optional(string)
    idle_session_ttl_seconds = optional(number, 600)
    guardrail_key            = optional(string)
    alias_name               = optional(string, "live")
  }))
  default = {}
}

# ----- Bedrock Mantle -----

variable "mantle_projects" {
  description = "Bedrock Mantle projects (OpenAI-compatible endpoint), keyed by project name."
  type = map(object({
    tags = optional(map(string), {})
  }))
  default = {}
}
