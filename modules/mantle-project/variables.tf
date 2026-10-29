variable "name" {
  description = "Name of the Bedrock Mantle project."
  type        = string
}

variable "tags" {
  description = "Tags for the project."
  type        = map(string)
  default     = {}
}
