// This template is for creating GKE clusters
// Please check this doc (https://www.terraform.io/docs/providers/google/r/container_cluster.html//addons_config) for
// more details about how to set up the parameters in ths template.
// Please note that this template wont create any node pool. But you can use the node pool template
// in the ../node-pool/node_pool.tf file to create the node pools.

// You need to set up the following variables in order to use this template to create a GKE cluster:
//
//   project_id
//   name
//   location
//   node_locations
//   network
//   subnetwork

terraform {
  # This template can only work with terraform 0.12 or later.
  required_version = ">= 0.12"
}

// google-beta provider is used in order to enable the beta settings.
provider "google-beta" {
  project = var.project_id
  region  = var.location
}

resource "google_container_cluster" "primary" {
  // Metadata
  //
  provider = "google-beta"
  name     = var.name
  description = var.description

  // Required paratmers
  //
  min_master_version = var.min_master_version
  location = var.location    // aka. region or zone
  node_locations = var.node_locations
  network = var.network
  subnetwork = var.subnetwork
  // We can't create a cluster with no node pool defined, but we want to only use
  // separately managed node pools. So we create the smallest possible default
  // node pool and immediately delete it, which means you need to create a node pool yourself.
  // `node_config` and `node_pool` and `node_version` are disabled as well.
  remove_default_node_pool = true
  initial_node_count = 1

  // Optional parameters
  //
  addons_config {
    horizontal_pod_autoscaling {
      disabled = var.horizontal_pod_autoscaling.disabled
    }

    http_load_balancing {
      disabled = var.http_load_balancing.disabled
    }

    kubernetes_dashboard {
      disabled = var.kubernetes_dashboard.disabled
    }

    network_policy_config {
      disabled = var.network_policy_config.disabled
    }

    istio_config {
      disabled = var.istio_config.disabled
      auth = var.istio_config.auth
    }

    cloudrun_config {
      disabled = var.cloudrun_config.disabled
    }
  }

  ip_allocation_policy {
    use_ip_aliases                  = var.use_ip_aliases
    // These settings cannot be dynamically set
    cluster_secondary_range_name    = var.cluster_secondary_range_name
    services_secondary_range_name   = var.services_secondary_range_name
    cluster_ipv4_cidr_block         = var.cluster_ipv4_cidr_block
    node_ipv4_cidr_block            = var.node_ipv4_cidr_block
    services_ipv4_cidr_block        = var.services_ipv4_cidr_block
    create_subnetwork               = var.create_subnetwork
    subnetwork_name                 = var.subnetwork_name
  }

  cluster_autoscaling {
    enabled = var.cluster_autoscaling.enabled
    dynamic "resource_limits" {
      iterator = resource_limit
      for_each = lookup(var.cluster_autoscaling, "resource_limits", [])
      content {
        resource_type = resource_limit.value.resource_type
        minimum = resource_limit.value.minimum
        maximum = resource_limit.value.maximum
      }
    }
  }

  database_encryption {
    state = var.database_encryption.state
    key_name = var.database_encryption.key_name
  }

  default_max_pods_per_node = var.default_max_pods_per_node

  enable_binary_authorization = var.enable_binary_authorization

  enable_kubernetes_alpha = var.enable_kubernetes_alpha

  enable_tpu = var.enable_tpu

  enable_legacy_abac = var.enable_tpu

  logging_service = var.logging_service

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_policy.daily_maintenance_window.start_time
    }
  }

  // Client certificate settings - disabled
  master_auth {
    username = var.master_auth.username
    password = var.master_auth.password

    client_certificate_config {
      issue_client_certificate = var.master_auth.issue_client_certificate
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      iterator = cidr_block
      for_each = lookup(var.master_authorized_networks_config, "cidr_blocks", [])
      content {
        cidr_block   = cidr_block.value.cidr_block
        display_name = lookup(cidr_block.value, "display_name", null)
      }
    }
  }

  monitoring_service = var.monitoring_service

  network_policy {
    enabled = var.network_policy.enabled
    provider = var.network_policy.provider
  }

  pod_security_policy_config {
    enabled = var.pod_security_policy_config.enabled
  }

  dynamic "authenticator_groups_config" {
    iterator = config
    for_each = var.authenticator_groups_config
    content {
      security_group = config.value.security_group
    }
  }

  private_cluster_config {
    enable_private_endpoint = var.private_cluster_config.enable_private_endpoint
    enable_private_nodes    = var.private_cluster_config.enable_private_nodes
    master_ipv4_cidr_block  = var.private_cluster_config.master_ipv4_cidr_block
  }

  resource_labels = var.resource_labels

  vertical_pod_autoscaling {
    enabled = var.vertical_pod_autoscaling.enabled
  }

  dynamic "workload_identity_config" {
    iterator = config
    for_each = var.workload_identity_config
    content {
      identity_namespace = config.value.identity_namespace
    }

  }

  enable_intranode_visibility = var.enable_intranode_visibility

  // The following settings are missing in terraform
  // - GKE usage metering
  // - Network egress metering
}
