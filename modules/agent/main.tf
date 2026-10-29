data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.region
  partition  = data.aws_partition.current.partition
}

resource "aws_iam_role" "this" {
  name_prefix = "bedrock-agent-${substr(var.name, 0, 20)}-"
  tags        = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "bedrock.amazonaws.com" }
      Action    = "sts:AssumeRole"
      Condition = {
        StringEquals = { "aws:SourceAccount" = local.account_id }
        ArnLike      = { "aws:SourceArn" = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:agent/*" }
      }
    }]
  })
}

resource "aws_iam_role_policy" "this" {
  role = aws_iam_role.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [{
        Effect = "Allow"
        Action = ["bedrock:InvokeModel", "bedrock:InvokeModelWithResponseStream", "bedrock:GetInferenceProfile"]
        Resource = [
          "arn:${local.partition}:bedrock:*::foundation-model/*",
          "arn:${local.partition}:bedrock:*:${local.account_id}:inference-profile/*",
          "arn:${local.partition}:bedrock:*:${local.account_id}:application-inference-profile/*",
        ]
      }],
      var.guardrail == null ? [] : [{
        Effect   = "Allow"
        Action   = "bedrock:ApplyGuardrail"
        Resource = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:guardrail/${var.guardrail.id}"
      }]
    )
  })
}

resource "aws_bedrockagent_agent" "this" {
  agent_name                  = var.name
  description                 = var.description
  agent_resource_role_arn     = aws_iam_role.this.arn
  foundation_model            = var.model_id
  instruction                 = var.instruction
  idle_session_ttl_in_seconds = var.idle_session_ttl_seconds
  tags                        = var.tags

  dynamic "guardrail_configuration" {
    for_each = var.guardrail == null ? [] : [var.guardrail]
    content {
      guardrail_identifier = guardrail_configuration.value.id
      guardrail_version    = guardrail_configuration.value.version
    }
  }

  depends_on = [aws_iam_role_policy.this]
}

resource "aws_bedrockagent_agent_alias" "this" {
  count = var.alias_name == null ? 0 : 1

  agent_id         = aws_bedrockagent_agent.this.agent_id
  agent_alias_name = var.alias_name
  tags             = var.tags
}
