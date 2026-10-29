variable "name_prefix" {
  description = "Prefix for the created bucket, log group and role."
  type        = string
  default     = "bedrock-invocation-logs"
}

variable "s3_enabled" {
  description = "Deliver logs to a new S3 bucket."
  type        = bool
  default     = true
}

variable "cloudwatch_enabled" {
  description = "Deliver logs to a new CloudWatch log group."
  type        = bool
  default     = false
}

variable "cloudwatch_retention_days" {
  description = "Retention for the CloudWatch log group."
  type        = number
  default     = 30
}

variable "log_text" {
  description = "Include text prompts/responses."
  type        = bool
  default     = true
}

variable "log_images" {
  description = "Include image data."
  type        = bool
  default     = false
}

variable "log_embeddings" {
  description = "Include embedding data."
  type        = bool
  default     = false
}

variable "log_video" {
  description = "Include video data."
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Allow destroying the S3 bucket even when it contains logs."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for created resources."
  type        = map(string)
  default     = {}
}
