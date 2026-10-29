variable "name" {
  description = "Agent name."
  type        = string
}

variable "description" {
  description = "Agent description."
  type        = string
  default     = null
}

variable "model_id" {
  description = "Model the agent uses: a foundation model ID, cross-region profile ID, or inference profile ARN."
  type        = string
}

variable "instruction" {
  description = "What the agent should do (40-20000 characters)."
  type        = string
}

variable "idle_session_ttl_seconds" {
  description = "Seconds before an idle session expires."
  type        = number
  default     = 600
}

variable "guardrail" {
  description = "Guardrail to attach. null = none."
  type = object({
    id      = string
    version = string
  })
  default = null
}

variable "alias_name" {
  description = "Create an alias pointing at the prepared agent. null = no alias."
  type        = string
  default     = "live"
}

variable "tags" {
  description = "Tags for created resources."
  type        = map(string)
  default     = {}
}
