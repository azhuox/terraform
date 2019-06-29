// This template is for creating GKE node pools.
// You can check this doc (https://www.terraform.io/docs/providers/google/r/container_node_pool.html) for more details
// about how to set up the parameters in ths template.

// You need to set up the following variables in order to use this template to create a GKE node pool:
//
//   project_id
//   cluster_name
//   name
//   location

terraform {
  // This template can only work with terraform 0.12 or later.
  required_version = ">= 0.12"
}

// google-beta provider is used in order to enable the beta settings.
provider "google-beta" {
  project = var.project_id
  region  = var.location
}

resource "google_container_node_pool" "primary" {
  // Required parameters
  //
  provider = "google-beta"
  cluster    = var.cluster_name
  name       = var.name
  location   = var.location

  // Optional Parameters
  //

  // Enable this and disable autoscaling if you want fixed number of the nodes.
  node_count = var.node_count

  // Enable this if you disable auto_upgrade in management block
  version = var.gke_version

  initial_node_count = var.initial_node_count

  dynamic "autoscaling" {
    iterator = config
    for_each = var.autoscaling
    content {
      min_node_count = config.value.min_node_count
      max_node_count = config.value.max_node_count
    }
  }

  management {
    auto_repair = var.management.auto_repair
    auto_upgrade = var.management.auto_upgrade
  }

  max_pods_per_node = var.max_pods_per_node

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  node_config {
    disk_size_gb = var.disk_size_gb

    disk_type    = var.disk_type

    guest_accelerator = var.guest_accelerator

    image_type = var.image_type

    labels = var.labels

    local_ssd_count = var.local_ssd_count

    machine_type = var.machine_type

    metadata = var.metadata

    min_cpu_platform = var.min_cpu_platform

    oauth_scopes = var.oauth_scopes

    preemptible = var.preemptible

    service_account = var.service_account

    tags = var.tags

    dynamic "taint" {
      iterator = t
      for_each = var.taints
      content {
        value = t.value.value
        key = t.value.key
        effect = t.value.effect
      }
    }

    dynamic "workload_metadata_config" {
      iterator = config
      for_each = var.workload_metadata_config
      content {
        node_metadata = config.value.node_metadata
      }
    }
  }
}
