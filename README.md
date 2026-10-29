# terraform-aws-bedrock

Discover AWS Bedrock foundation models and instantiate one as your own
**application inference profile** (optionally with **provisioned throughput**).

## Prerequisites

- Terraform >= 1.5, AWS provider >= 5.80
- AWS credentials with `bedrock:*` permissions for the target region
- Model access enabled in the Bedrock console (Anthropic models need a one-time use-case form)

## 1. Discover models

```bash
cp terraform.tfvars.example terraform.tfvars   # edit filters
terraform init
terraform plan                                  # `available_models` output lists matches
```

Or query interactively without creating anything:

```bash
terraform console
> [for m in data.aws_bedrock_foundation_models.available.model_summaries : m.model_id]
```

## 2. Instantiate a model

Set `model_id` and `name` in `terraform.tfvars`, then:

```bash
terraform apply
```

Use the `inference_profile_arn` output as `modelId` in your Bedrock calls:

```bash
aws bedrock-runtime converse \
  --model-id "$(terraform output -raw inference_profile_arn)" \
  --messages '[{"role":"user","content":[{"text":"Hello"}]}]'
```

Newer models (for example recent Claude versions) only support cross-region inference.
For those, also set `system_inference_profile_id` (for example `us.anthropic...`).

## Provisioned throughput

`enable_provisioned_throughput = true` reserves dedicated capacity. It is **billed hourly
and is expensive**, and commitments (`OneMonth` / `SixMonths`) can't be cancelled.
Leave it off unless you need guaranteed throughput.

## Cleanup

```bash
terraform destroy
```
