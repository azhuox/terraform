// Create a VPC network for the cluster.
// Check this doc (https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier) for more details.
module "vpc_network" {
  source = "github.com/gruntwork-io/terraform-google-network.git//modules/vpc-network?ref=v0.2.1"

  name_prefix = "${var.cluster_name}-network-${random_string.suffix.result}"
  project     = var.project_id
  region      = var.location

  cidr_block           = "10.68.0.0/16"
  secondary_cidr_block = "10.69.0.0/16"
}

// Use a random suffix to prevent overlap in network names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

// Use the template to create a (public) GKE cluster.
module "cluster" {
  source              = "../../../../modules/gcp/gke/cluster"
  project_id          = var.project_id
  name                = var.cluster_name
  description         = "Gke cluster demo"
  location            = var.location
  node_locations      = ["us-central1-a", "us-central1-b"]
  network             = module.vpc_network.network
  subnetwork          = module.vpc_network.public_subnetwork  // Use the `public` subnetwork allow outbound internet access.
  cluster_autoscaling = {
    enabled = true,
    resource_limits = [
      {
        resource_type = "cpu"
        minimum = 1
        maximum = 10
      },
      {
        resource_type = "memory"
        minimum = 1
        maximum = 32
      }
    ],
  }
  resource_labels    = {resource1 = "cpu", resource2 = "memory"}
}

// Use the template to create a node pool for the above cluster.
module "default_node_pool" {
  source              = "../../../../modules/gcp/gke/node-pool"
  project_id          = var.project_id
  cluster_name        = module.cluster.name
  name                = "default-node-pool"
  location            = "us-central1"
  machine_type        = "n1-standard-1"
  labels              = {type = "default-node-pool"}
  tags                = ["test-cluster", "default-node-pool"]
  initial_node_count  = 1 // Per zone
  autoscaling         = [{min_node_count = 1, max_node_count = 3}]  // Per zone
  taints              = [
    {
      key = "node-type"
      value = "default-node-pool"
      effect = "PREFER_NO_SCHEDULE"
    }
  ]
}


// You can configure a google cloud storage bucket fore storing terraform states.
// Check this doc for more details: https://www.terraform.io/docs/backends/types/gcs.html
//terraform {
//  backend "gcs" {
//    bucket = "terraform-state-store"
//    prefix = "gke-clusters/demo"
//  }
//}
