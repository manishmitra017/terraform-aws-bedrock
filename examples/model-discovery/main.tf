# Lists models without creating anything: terraform init && terraform plan
module "bedrock" {
  # From another repo use:
  # source = "github.com/manishmitra017/terraform-aws-bedrock?ref=v1.0.0"
  source = "../.."

  model_catalog = {
    provider_name   = "Anthropic"
    output_modality = "TEXT"
  }
}

output "models" {
  value = module.bedrock.available_models
}
