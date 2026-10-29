resource "aws_bedrock_guardrail" "this" {
  name                      = var.name
  description               = var.description
  blocked_input_messaging   = var.blocked_input_message
  blocked_outputs_messaging = var.blocked_output_message
  kms_key_arn               = var.kms_key_arn
  tags                      = var.tags

  dynamic "content_policy_config" {
    for_each = length(var.content_filters) > 0 ? [1] : []
    content {
      dynamic "filters_config" {
        for_each = var.content_filters
        content {
          type            = filters_config.key
          input_strength  = filters_config.value.input_strength
          output_strength = filters_config.value.output_strength
        }
      }
    }
  }

  dynamic "topic_policy_config" {
    for_each = length(var.denied_topics) > 0 ? [1] : []
    content {
      dynamic "topics_config" {
        for_each = var.denied_topics
        content {
          name       = topics_config.key
          definition = topics_config.value.definition
          examples   = topics_config.value.examples
          type       = "DENY"
        }
      }
    }
  }

  dynamic "sensitive_information_policy_config" {
    for_each = length(var.pii_entities) + length(var.regexes) > 0 ? [1] : []
    content {
      dynamic "pii_entities_config" {
        for_each = var.pii_entities
        content {
          type   = pii_entities_config.key
          action = pii_entities_config.value
        }
      }
      dynamic "regexes_config" {
        for_each = var.regexes
        content {
          name        = regexes_config.key
          pattern     = regexes_config.value.pattern
          action      = regexes_config.value.action
          description = regexes_config.value.description
        }
      }
    }
  }

  dynamic "word_policy_config" {
    for_each = length(var.blocked_words) > 0 || var.block_profanity ? [1] : []
    content {
      dynamic "managed_word_lists_config" {
        for_each = var.block_profanity ? [1] : []
        content {
          type = "PROFANITY"
        }
      }
      dynamic "words_config" {
        for_each = var.blocked_words
        content {
          text = words_config.value
        }
      }
    }
  }

  dynamic "contextual_grounding_policy_config" {
    for_each = var.grounding_threshold == null ? [] : [1]
    content {
      filters_config {
        type      = "GROUNDING"
        threshold = var.grounding_threshold
      }
      filters_config {
        type      = "RELEVANCE"
        threshold = var.grounding_threshold
      }
    }
  }
}

resource "aws_bedrock_guardrail_version" "this" {
  count = var.create_version ? 1 : 0

  guardrail_arn = aws_bedrock_guardrail.this.guardrail_arn
  description   = var.description
}
