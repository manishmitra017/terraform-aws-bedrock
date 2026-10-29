variable "region" {
  description = "AWS region where Bedrock is used."
  type        = string
  default     = "us-east-1"
}

# ---------- Model discovery filters (all optional) ----------

variable "filter_provider" {
  description = "Only list models from this provider, e.g. \"Anthropic\", \"Amazon\", \"Meta\". null = all."
  type        = string
  default     = null
}

variable "filter_output_modality" {
  description = "Only list models with this output modality: TEXT, IMAGE or EMBEDDING. null = all."
  type        = string
  default     = null
}

variable "filter_inference_type" {
  description = "Only list models supporting this inference type: ON_DEMAND or PROVISIONED. null = all."
  type        = string
  default     = null
}

# ---------- Model to instantiate ----------

variable "model_id" {
  description = "Foundation model ID to build on, e.g. \"amazon.nova-pro-v1:0\". Pick one from the `available_models` output."
  type        = string
}

variable "system_inference_profile_id" {
  description = <<-EOT
    Optional cross-region (system) inference profile ID, e.g. "us.anthropic.claude-sonnet-4-5-20250929-v1:0".
    Required for newer models that don't support ON_DEMAND directly (most recent Claude models).
    When set, the application inference profile copies from this profile instead of the raw model.
  EOT
  type        = string
  default     = null
}

variable "name" {
  description = "Name for your application inference profile."
  type        = string
}

variable "tags" {
  description = "Tags applied to created resources (useful for cost allocation)."
  type        = map(string)
  default     = {}
}

# ---------- Provisioned throughput (expensive, off by default) ----------

variable "enable_provisioned_throughput" {
  description = "Create dedicated provisioned throughput. WARNING: billed hourly, often at high cost."
  type        = bool
  default     = false
}

variable "provisioned_model_units" {
  description = "Number of model units for provisioned throughput."
  type        = number
  default     = 1
}

variable "provisioned_commitment_duration" {
  description = "OneMonth, SixMonths, or null for no commitment (hourly)."
  type        = string
  default     = null
}
