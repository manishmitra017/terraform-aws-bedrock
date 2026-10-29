variable "provider_name" {
  description = "Only list models from this provider, e.g. \"Anthropic\", \"Amazon\", \"Meta\". null = all."
  type        = string
  default     = null
}

variable "output_modality" {
  description = "Only list models with this output modality: TEXT, IMAGE or EMBEDDING. null = all."
  type        = string
  default     = null
}

variable "inference_type" {
  description = "Only list models supporting this inference type: ON_DEMAND or PROVISIONED. null = all."
  type        = string
  default     = null
}

variable "customization_type" {
  description = "Only list models supporting this customization: FINE_TUNING, CONTINUED_PRE_TRAINING or DISTILLATION. null = all."
  type        = string
  default     = null
}
