module "bedrock" {
  source = "../.."

  inference_profiles = {
    # Plain foundation model
    "my-app-nova-pro" = {
      model_id = "amazon.nova-pro-v1:0"
    }
    # Newer Claude models are reached through a cross-region system profile
    "my-app-claude-sonnet" = {
      model_id    = "us.anthropic.claude-sonnet-4-5-20250929-v1:0"
      source_type = "inference-profile"
    }
  }

  tags = { project = "my-app" }
}

output "inference_profiles" {
  value = module.bedrock.inference_profiles
}
