data "kibana_index" "cloudwatch" {
  filter = {
    name = "title"
    values = ["cloudwatch-*"]
  }
}