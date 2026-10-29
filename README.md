# terraform-aws-bedrock

A modular Terraform setup for turning on **Amazon Bedrock** services and **Bedrock Mantle**
(the OpenAI-compatible endpoint). Every service is **off by default**. Set the matching
input to switch it on.

| Service | Input | Module |
|---|---|---|
| Model discovery | `model_catalog` | [`modules/model-catalog`](modules/model-catalog) |
| Model access (Marketplace agreements, Anthropic form) | `model_access` | [`modules/model-access`](modules/model-access) |
| Application inference profiles | `inference_profiles` | [`modules/inference-profile`](modules/inference-profile) |
| Provisioned throughput ⚠️ expensive | `provisioned_throughputs` | [`modules/provisioned-throughput`](modules/provisioned-throughput) |
| Guardrails | `guardrails` | [`modules/guardrail`](modules/guardrail) |
| Model invocation logging (S3 / CloudWatch) | `invocation_logging` | [`modules/invocation-logging`](modules/invocation-logging) |
| Agents (with IAM role and alias) | `agents` | [`modules/agent`](modules/agent) |
| Bedrock Mantle projects | `mantle_projects` | [`modules/mantle-project`](modules/mantle-project) |

## Usage

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "awscc" {
  region = "us-east-1" # used for Bedrock Mantle
}

module "bedrock" {
  source = "github.com/manishmitra017/terraform-aws-bedrock?ref=v1.0.0"

  model_catalog = { provider_name = "Anthropic" }

  inference_profiles = {
    "my-app-claude" = {
      model_id    = "us.anthropic.claude-sonnet-4-5-20250929-v1:0"
      source_type = "inference-profile"
    }
  }

  guardrails = {
    "default" = { pii_entities = { EMAIL = "ANONYMIZE" } }
  }

  agents = {
    "support-agent" = {
      model_id      = "us.anthropic.claude-sonnet-4-5-20250929-v1:0"
      instruction   = "You are a helpful support assistant for our product."
      guardrail_key = "default"
    }
  }

  mantle_projects = { "my-app" = {} }
}
```

You can also use a single service on its own:

```hcl
module "guardrail" {
  source = "github.com/manishmitra017/terraform-aws-bedrock//modules/guardrail?ref=v1.0.0"
  name   = "default"
}
```

## Examples

- [`examples/model-discovery`](examples/model-discovery): lists models without creating anything
- [`examples/inference-profile`](examples/inference-profile): one foundation-model profile and one cross-region profile
- [`examples/complete`](examples/complete): turns on every service

```bash
cd examples/model-discovery
terraform init
terraform plan   # the models appear in the outputs
```

## Finding models

- `available_models` returns every model matching your filters, keyed by model ID.
- Newer models (for example recent Claude versions) only support cross-region inference.
  Use the system profile ID (`us.…`, `eu.…`, `global.…`) and set `source_type = "inference-profile"`.
- To call a model, pass the `inference_profiles` output ARN as `modelId` to `InvokeModel` / `Converse`.

## Notes

- **Provisioned throughput** is billed hourly per model unit. `OneMonth` / `SixMonths` commitments can't be cancelled.
- **Invocation logging** is account-wide for a region. Only one configuration can exist per region.
- **Anthropic use-case form** only needs to be sent once per account. Remove `anthropic_use_case` after the first apply.
- **Mantle** resources use the [`awscc`](https://registry.terraform.io/providers/hashicorp/awscc) provider. Configure it even if you only use the AWS resources.

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.5 |
| aws | >= 6.0 |
| awscc | >= 1.70 |

## License

MIT
