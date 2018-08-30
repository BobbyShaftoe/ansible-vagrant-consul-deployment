provider "kibana" {

  kibana_version = "5.6.1"
  kibana_uri = "http://10.20.0.175:5601"
  kibana_username = "admin"
  kibana_password = "xxxxxxxx"
}


//resource "kibana_search" "cloudwatch_ec2" {
//  name 	        = "Cloudwatch origin - errors"
//  description     = "Errors occured when source was from EC2"
//  display_columns = ["_source"]
//  sort_by_columns = ["@timestamp"]
//  search = {
//    index   = "${data.kibana_index.main.id}"
//    filters = [
//      {
//        match = {
//          field_name = "geo.src"
//          query      = "CN"
//          type       = "phrase"
//        },
//      },
//      {
//        match = {
//          field_name = "@tags"
//          query      = "error"
//          type       = "phrase"
//        }
//      }
//    ]
//  }
//}



resource "kibana_visualization" "cloudwatch_visualization_bbb" {
  name = "Cloudwatch Visualization BBB"
  description = "Cloudwatch EC2 Event Name"
  saved_search_id = "AWGeZx4EGEANE5wMMnD6"

  visualization_state = <<EOF
{
    "title": "Cloudwatch EC2 Event Name",
    "type": "pie",
    "params": {
      "addTooltip": true,
      "addLegend": true,
      "legendPosition": "bottom",
      "isDonut": false
    },
    "aggs": [
      {
        "id": "1",
        "enabled": true,
        "type": "count",
        "schema": "metric",
        "params": {}
      },
      {
        "id": "2",
        "enabled": true,
        "type": "terms",
        "schema": "segment",
        "params": {
        "field": "detail.eventName.keyword",
        "size": 12,
        "order": "asc",
        "orderBy": "_term"
        }
      }
    ],
    "listeners": {}
    }
EOF
}


resource "kibana_visualization" "cloudwatch_visualization_ccc" {
  name = "Cloudwatch Visualization CCC"
  description = "Cloudwatch EC2 Source IP"
  saved_search_id = "AWGeZx4EGEANE5wMMnD6"

  visualization_state = <<EOF
{
    "title": "Cloudwatch EC2 Source IP",
    "type": "pie",
    "params": {
      "addTooltip": true,
      "addLegend": true,
      "legendPosition": "bottom",
      "isDonut": false
    },
    "aggs": [
      {
        "id": "1",
        "enabled": true,
        "type": "count",
        "schema": "metric",
        "params": {}
      },
      {
        "id": "2",
        "enabled": true,
        "type": "terms",
        "schema": "segment",
        "params": {
        "field": "detail.sourceIPAddress.keyword",
        "size": 12,
        "order": "asc",
        "orderBy": "_term"
        }
      }
    ],
    "listeners": {}
    }
EOF
}








resource "kibana_visualization" "cloudwatch_visualization_aaa" {
  name = "Cloudwatch Visualization AAA"
  description = "Cloudwatch Visualization AAA"
  saved_search_id = "AWGeZx4EGEANE5wMMnD6"

  visualization_state = <<EOF
{
  "title": "Cloudwatch Events Table AAA",
  "type": "table",
  "params": {
    "perPage": 20,
    "showPartialRows": true,
    "showMeticsAtAllLevels": false,
    "sort": {
      "columnIndex": null,
      "direction": null
    },
    "showTotal": true,
    "totalFunc": "sum"
  },
  "aggs": [
    {
      "id": 1,
      "enabled": true,
      "type": "count",
      "schema": "metric",
      "params": {
      }
    },
    {
      "id": 4,
      "enabled": true,
      "type": "date_histogram",
      "schema": "bucket",
      "params": {
        "field": "detail.userIdentity.sessionContext.attributes.creationDate",
        "interval": "h",
        "customInterval": "2h",
        "min_doc_count": 1,
        "extended_bounds": {
        },
        "customLabel": "Timeframe"
      }
    },
    {
      "id": 2,
      "enabled": true,
      "type": "terms",
      "schema": "bucket",
      "params": {
        "field": "detail.eventName.keyword",
        "size": 14,
        "order": "desc",
        "orderBy": 1,
        "customLabel": "Event Type"
      }
    },
    {
      "id": 3,
      "enabled": true,
      "type": "terms",
      "schema": "bucket",
      "params": {
        "field": "detail.sourceIPAddress.keyword",
        "size": 5,
        "order": "desc",
        "orderBy": 1,
        "customLabel": "Source IP"
      }
    },
    {
      "id": 5,
      "enabled": true,
      "type": "terms",
      "schema": "bucket",
      "params": {
        "field": "detail.userIdentity.type.keyword",
        "size": 5,
        "order": "desc",
        "orderBy": 1,
        "customLabel": "User Identity"
      }
    },
    {
      "id": 6,
      "enabled": true,
      "type": "terms",
      "schema": "bucket",
      "params": {
        "field": "detail.userIdentity.userName.keyword",
        "size": 100,
        "order": "desc",
        "orderBy": 1,
        "customLabel": "Username"
      }
    },
    {
      "id": 7,
      "enabled": true,
      "type": "terms",
      "schema": "bucket",
      "params": {
        "field": "detail.userIdentity.arn.keyword",
        "size": 100,
        "order": "desc",
        "orderBy": 1,
        "customLabel": "IAM User"
      }
    }
  ],
  "listeners": {
  }
}
EOF
}


resource "kibana_dashboard" "cloudwatch_dashboard" {
  name = "Example Dashboard AAA"
  description = "Example dashboard - created with Terraform"
  panels_json = <<EOF
  [
    {
      "col": 1,
      "id": "${kibana_visualization.cloudwatch_visualization_aaa.id}",
      "panelIndex": 1,
      "row": 1,
      "size_x": 12,
      "size_y": 4,
      "type": "visualization"
    },
    {
      "col": 1,
      "id": "${kibana_visualization.cloudwatch_visualization_bbb.id}",
      "panelIndex": 2,
      "row": 5,
      "size_x": 6,
      "size_y": 6,
      "type": "visualization"
    },
    {
      "col": 7,
      "id": "${kibana_visualization.cloudwatch_visualization_ccc.id}",
      "panelIndex": 3,
      "row": 5,
      "size_x": 6,
      "size_y": 6,
      "type": "visualization"
    }
  ]
EOF
}








//
//
//resource "kibana_dashboard" "cloudwatch_dashboard" {
//  name = "Example Dashboard AAA"
//  description = "Example dashboard - created with Terraform"
//  panels_json = <<EOF
//[
//  {
//    "gridData": {
//      "w": 6,
//      "h": 3,
//      "x": 0,
//      "y": 0,
//      "i": "1"
//    },
//    "version": "5.6.1",
//    "panelIndex": "1",
//    "type": "visualization",
//    "id": "${kibana_visualization.cloudwatch_visualization_aaa.id}"
//  },
//  {
//    "gridData": {
//      "w": 6,
//      "h": 3,
//      "x": 6,
//      "y": 0,
//      "i": "2"
//    },
//    "version": "5.6.1",
//    "panelIndex": "2",
//    "type": "visualization",
//    "id": "${kibana_visualization.cloudwatch_visualization_aaa.id}"
//  }
//]
//EOF
//}