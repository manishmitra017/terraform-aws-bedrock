variable "anthropic_use_case" {
  description = <<-EOT
    One-time Anthropic first-time-use form for the account. null = skip (already submitted).
    See https://docs.aws.amazon.com/bedrock/latest/APIReference/API_PutUseCaseForModelAccess.html
  EOT
  type = object({
    company_name    = string
    company_website = string
    intended_users  = string # "0" = internal employees, "1" = external users, "2" = both
    industry        = string
    use_cases       = string
  })
  default = null
}

variable "model_ids" {
  description = "Model IDs to accept the public Marketplace offer for (enables access to that model)."
  type        = set(string)
  default     = []
}
