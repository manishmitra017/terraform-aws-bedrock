variable "name" {
  description = "Name of the provisioned throughput."
  type        = string
}

variable "model_arn" {
  description = "ARN of the foundation or custom model. Use model_id instead for foundation models."
  type        = string
  default     = null
}

variable "model_id" {
  description = "Foundation model ID. Ignored if model_arn is set."
  type        = string
  default     = null
}

variable "model_units" {
  description = "Number of model units."
  type        = number
  default     = 1
}

variable "commitment_duration" {
  description = "OneMonth, SixMonths, or null for no commitment (hourly; custom models only)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for the resource."
  type        = map(string)
  default     = {}
}
