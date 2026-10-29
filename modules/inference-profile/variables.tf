variable "name" {
  description = "Name of the application inference profile."
  type        = string
}

variable "description" {
  description = "Description of the profile."
  type        = string
  default     = null
}

variable "model_id" {
  description = <<-EOT
    What the profile routes to. Either a foundation model ID (e.g. "amazon.nova-pro-v1:0")
    or a system cross-region inference profile ID (e.g. "us.anthropic.claude-sonnet-4-5-20250929-v1:0").
  EOT
  type        = string
}

variable "source_type" {
  description = "\"foundation-model\" or \"inference-profile\" (use the latter for cross-region IDs like us.*, eu.*, global.*)."
  type        = string
  default     = "foundation-model"

  validation {
    condition     = contains(["foundation-model", "inference-profile"], var.source_type)
    error_message = "source_type must be \"foundation-model\" or \"inference-profile\"."
  }
}

variable "tags" {
  description = "Tags for the profile (useful for cost allocation)."
  type        = map(string)
  default     = {}
}
