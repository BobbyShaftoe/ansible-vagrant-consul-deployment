output "cloudwatch_index_id" {
  value = "${data.kibana_index.cloudwatch.id}"
}

output "cloudwatch_visualisation_aaa_saved_search_id" {
  value = "${kibana_visualization.cloudwatch_visualization_aaa.saved_search_id}"
}

output "cloudwatch_visualisation_aaa_id" {
  value = "${kibana_visualization.cloudwatch_visualization_aaa.id}"
}

output "cloudwatch_visualisation_aaa_description" {
  value = "${kibana_visualization.cloudwatch_visualization_aaa.description}"
}

output "cloudwatch_visualisation_aaa_visualization_state" {
  value = "${kibana_visualization.cloudwatch_visualization_aaa.visualization_state}"
}

output "cloudwatch_visualisation_aaa_name" {
  value = "${kibana_visualization.cloudwatch_visualization_aaa.name}"
}



output "cloudwatch_visualisation_bbb_saved_search_id" {
  value = "${kibana_visualization.cloudwatch_visualization_bbb.saved_search_id}"
}

output "cloudwatch_visualisation_bbb_id" {
  value = "${kibana_visualization.cloudwatch_visualization_bbb.id}"
}

output "cloudwatch_visualisation_bbb_description" {
  value = "${kibana_visualization.cloudwatch_visualization_bbb.description}"
}

output "cloudwatch_visualisation_bbb_visualization_state" {
  value = "${kibana_visualization.cloudwatch_visualization_bbb.visualization_state}"
}

output "cloudwatch_visualisation_bbb_name" {
  value = "${kibana_visualization.cloudwatch_visualization_bbb.name}"
}



output "cloudwatch_dashboard_description" {
  value = "${kibana_dashboard.cloudwatch_dashboard.description}"
}

output "cloudwatch_dashboard_name" {
  value = "${kibana_dashboard.cloudwatch_dashboard.name}"
}

output "cloudwatch_dashboard_id" {
  value = "${kibana_dashboard.cloudwatch_dashboard.id}"
}

output "cloudwatch_dashboard_description_panels_json" {
  value = "${kibana_dashboard.cloudwatch_dashboard.panels_json}"
}



//output "cloudwatch_dashboard_id" {
//  value = "${kibana_dashboard.cloudwatch_dashboard.description}"
//}

