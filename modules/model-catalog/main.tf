data "aws_bedrock_foundation_models" "this" {
  by_provider           = var.provider_name
  by_output_modality    = var.output_modality
  by_inference_type     = var.inference_type
  by_customization_type = var.customization_type
}
