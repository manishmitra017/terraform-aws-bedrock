# Turns on every service the module supports. Remove what you don't need.
module "bedrock" {
  source = "../.."

  tags = { project = "my-app", env = "dev" }

  model_catalog = {
    output_modality = "TEXT"
  }

  model_access = {
    model_ids = ["anthropic.claude-sonnet-4-5-20250929-v1:0"]
    # One-time per account; remove once submitted.
    anthropic_use_case = {
      company_name    = "Example Corp"
      company_website = "https://example.com"
      intended_users  = "0"
      industry        = "Technology"
      use_cases       = "Internal developer assistant and document summarization."
    }
  }

  inference_profiles = {
    "my-app-claude" = {
      model_id    = "us.anthropic.claude-sonnet-4-5-20250929-v1:0"
      source_type = "inference-profile"
    }
  }

  guardrails = {
    "default" = {
      description  = "Baseline content safety"
      pii_entities = { EMAIL = "ANONYMIZE", PHONE = "ANONYMIZE", US_SOCIAL_SECURITY_NUMBER = "BLOCK" }
      denied_topics = {
        investment_advice = {
          definition = "Recommendations about where or how to invest money."
          examples   = ["Which stocks should I buy?"]
        }
      }
    }
  }

  invocation_logging = {
    cloudwatch_enabled = true
  }

  agents = {
    "support-agent" = {
      model_id      = "us.anthropic.claude-sonnet-4-5-20250929-v1:0"
      instruction   = "You are a helpful support assistant. Answer questions about our product clearly and concisely."
      guardrail_key = "default"
    }
  }

  mantle_projects = {
    "my-app" = {}
  }

  # Provisioned throughput is expensive; uncomment only if you need it.
  # provisioned_throughputs = {
  #   "my-app-dedicated" = {
  #     model_id            = "amazon.nova-pro-v1:0"
  #     model_units         = 1
  #     commitment_duration = "OneMonth"
  #   }
  # }
}

output "bedrock" {
  value = module.bedrock
}
