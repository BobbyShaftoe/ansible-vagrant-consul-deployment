data "kibana_index" "cloudwatch" {
  filter = {
    name = "title"
    values = ["cloudwatch*"]
  }
}

//data "kibana_visualization" "vis1" {
//  filter = {
//    name = "title"
//    values = ["Cloudwatch Events Table"]
//  }
//}

