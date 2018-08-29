provider "kibana" {
  version = "~> 0.6"
  kibana_version = "5.6.1"
  kibana_uri = "http://10.20.0.175:5601"
}

resource "kibana_dashboard" "cloudwatch_dashboard" {
  name = "Example Dashboard AAA"
  description = "Example dashboard - created with Terraform"
  panels_json = <<EOF
[
  {
    "gridData": {
      "w": 6,
      "h": 3,
      "x": 0,
      "y": 0,
      "i": "1"
    },
    "version": "5.6.1",
    "panelIndex": "1",
    "type": "visualization",
    "id": "AWGVmTbDGEANE5wMMcNw"
  },
  {
    "gridData": {
      "w": 6,
      "h": 3,
      "x": 6,
      "y": 0,
      "i": "2"
    },
    "version": "5.6.1",
    "panelIndex": "2",
    "type": "visualization",
    "id": "AWGeRyGGGEANE5wMMm51"
  }
]
EOF
}