resource "aws_bedrock_use_case_for_model_access" "anthropic" {
  count = var.anthropic_use_case == null ? 0 : 1

  form_data = jsonencode({
    companyName         = var.anthropic_use_case.company_name
    companyWebsite      = var.anthropic_use_case.company_website
    intendedUsers       = var.anthropic_use_case.intended_users
    industryOption      = var.anthropic_use_case.industry
    otherIndustryOption = ""
    useCases            = var.anthropic_use_case.use_cases
  })
}

data "aws_bedrock_foundation_model_agreement_offers" "this" {
  for_each = var.model_ids

  model_id   = each.value
  offer_type = "PUBLIC"
}

resource "aws_bedrock_foundation_model_agreement" "this" {
  for_each = var.model_ids

  model_id    = each.value
  offer_token = data.aws_bedrock_foundation_model_agreement_offers.this[each.key].offers[0].offer_token

  lifecycle {
    ignore_changes = [offer_token]
  }

  depends_on = [aws_bedrock_use_case_for_model_access.anthropic]
}
