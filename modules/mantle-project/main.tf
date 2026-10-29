resource "awscc_bedrockmantle_project" "this" {
  name = var.name
  tags = [for k, v in var.tags : { key = k, value = v }]
}
