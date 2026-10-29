variable "name" {
  description = "Name of the guardrail."
  type        = string
}

variable "description" {
  description = "Description of the guardrail."
  type        = string
  default     = null
}

variable "blocked_input_message" {
  description = "Message returned when a prompt is blocked."
  type        = string
  default     = "Sorry, I can't help with that request."
  nullable    = false
}

variable "blocked_output_message" {
  description = "Message returned when a model response is blocked."
  type        = string
  default     = "Sorry, I can't provide that response."
  nullable    = false
}

variable "content_filters" {
  description = "Content filters keyed by type (SEXUAL, VIOLENCE, HATE, INSULTS, MISCONDUCT, PROMPT_ATTACK). Strength: NONE, LOW, MEDIUM, HIGH."
  type = map(object({
    input_strength  = string
    output_strength = string
  }))
  default = {
    SEXUAL        = { input_strength = "HIGH", output_strength = "HIGH" }
    VIOLENCE      = { input_strength = "HIGH", output_strength = "HIGH" }
    HATE          = { input_strength = "HIGH", output_strength = "HIGH" }
    INSULTS       = { input_strength = "HIGH", output_strength = "HIGH" }
    MISCONDUCT    = { input_strength = "HIGH", output_strength = "HIGH" }
    PROMPT_ATTACK = { input_strength = "HIGH", output_strength = "NONE" }
  }
  nullable = false
}

variable "denied_topics" {
  description = "Topics the model must refuse, keyed by name."
  type = map(object({
    definition = string
    examples   = optional(list(string), [])
  }))
  default  = {}
  nullable = false
}

variable "pii_entities" {
  description = "PII entity types mapped to an action: BLOCK or ANONYMIZE. E.g. { EMAIL = \"ANONYMIZE\" }."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "regexes" {
  description = "Custom sensitive-data regexes keyed by name."
  type = map(object({
    pattern     = string
    action      = optional(string, "BLOCK")
    description = optional(string)
  }))
  default  = {}
  nullable = false
}

variable "blocked_words" {
  description = "Exact words or phrases to block."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "block_profanity" {
  description = "Enable the managed profanity word list."
  type        = bool
  default     = false
  nullable    = false
}

variable "grounding_threshold" {
  description = "Contextual grounding threshold (0-0.99) for GROUNDING and RELEVANCE checks. null = disabled."
  type        = number
  default     = null
}

variable "create_version" {
  description = "Publish an immutable version of the guardrail."
  type        = bool
  default     = true
  nullable    = false
}

variable "kms_key_arn" {
  description = "KMS key to encrypt the guardrail. null = AWS-owned key."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for the guardrail."
  type        = map(string)
  default     = {}
  nullable    = false
}
