//----------------------------------------------------------------------------------------------------------------------
// Required parameters
//----------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The ID of the project in which the cluster belongs."
  type = string
}

variable "name" {
  description = "The name of the cluster."
  type = string
}

variable "location" {
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location."
  type = string
}

variable "node_locations" {
  description = "The list of zones in which the cluster's nodes should be located. These must be in the same region as the cluster zone for zonal clusters, or in the region of a regional cluster."
  type = list(string)
}

variable "network" {
  description = "The name or self link of the Google Compute Engine (GCE) network to which the cluster is connected."
  type = string
}

variable "subnetwork" {
  description = "The name or self link of the GCE subnetwork in which the cluster's instances are launched."
  type = string
}

//----------------------------------------------------------------------------------------------------------------------
// Optional parameters
// These parameters have default values and they can be overriden based on your need.
//----------------------------------------------------------------------------------------------------------------------

variable "description" {
  description = "The description of the cluster"
  type = string
  default = null
}

variable "min_master_version" {
  description = "The minimum k8s version of the master. The `latest` specifies the highest supported Kubernetes version currently available on GKE in the cluster's zone or region."
  type = string
  default = "latest"
}

//--------------------------------------------------------------------------------
// Addons configs
//
variable "horizontal_pod_autoscaling" {
  description = "The configuration of the Horizontal Pod Autoscaling addon."
  type = object({
    disabled = bool
  })
  default = {
    disabled = false
  }
}

variable "http_load_balancing" {
  description = "The configuration of the HTTP (L7) load balancing addon."
  type = object({
    disabled = bool
  })
  default = {
    disabled = false
  }
}

variable "network_policy_config" {
  description = "The configuration of the network policy addon for the master. This must be enabled in order to enable network policy for the nodes."
  type = object({
    disabled = bool
  })
  default = {
    disabled = false
  }
}

variable "istio_config" {
  description = "The configuration of the istio addon."
  type = object({
    disabled = bool
    auth = string
  })
  default = {
    disabled = true
    auth = "AUTH_NONE"
  }
}

// You need to enable `istio_config` in order to enable cloud run
variable "cloudrun_config" {
  description = "The configuration of the CloudRun addon. The istio_config must be enabled in order to enable CloudRun."
  type = object({
    disabled = bool
  })
  default = {
    disabled = true
  }
}
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
// IP allocation policies
//
variable "use_ip_aliases" {
  description = "Whether to use alias IPs for pod IPs in the cluster."
  type = bool
  default = true
}

variable "cluster_secondary_range_name" {
  description = " The name of the secondary range to be used as for the cluster CIDR block. The secondary range will be used for pod IP addresses."
  type = string
  default = null
}

variable "services_secondary_range_name" {
  description = "The name of the secondary range to be used as for the services CIDR block. The secondary range will be used for service ClusterIPs."
  type = string
  default = null
}

variable "cluster_ipv4_cidr_block" {
  description = "The IP address range for the cluster pod IPs. Set to blank to have a range chosen with the default size by GKE."
  type = string
  default = null
}

variable "node_ipv4_cidr_block" {
  description = "The IP address range of the node IPs in this cluster. This should be set only if create_subnetwork is true. Set to blank to have a range chosen with the default size by GKE."
  type = string
  default = null
}

variable "services_ipv4_cidr_block" {
  description = "The IP address range of the services IPs in this cluster. Set to blank to have a range chosen with the default size by GKE."
  type = string
  default = null
}

variable "create_subnetwork" {
  description = "Whether to automatically new subnetwork for the cluster."
  type = bool
  default = false
}

variable "subnetwork_name" {
  description = "A custom subnetwork name to be used if create_subnetwork is true. Set to blank to have a name chosen by GKE."
  type = string
  default = null
}
//--------------------------------------------------------------------------------

variable "cluster_autoscaling" {
  description = "The configuration of the cluster autoscaling features. Check [this doc](https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-provisioning) for more details."
  type = object({
    enabled = bool
    resource_limits = list(object({
      resource_type = string
      minimum = number
      maximum = number
    }))
  })
  default = {
    enabled = false
    resource_limits = []
  }
}

variable "database_encryption" {
  description = "The configuration of database encryption features, which are used to encrypty/decrypt secrets."
  type = object({
    state = string
    key_name = string
  })
  default = {
    state = "DECRYPTED"
    key_name = ""
  }
}

variable "default_max_pods_per_node" {
  description = "The default maximum number of pods per node in this cluster. It is 110 by default."
  type = number
  default = 110
}

variable "enable_binary_authorization" {
  description = "Whether to enable (container images) Binary Authorization for this cluster."
  type = bool
  default = true
}

variable "enable_kubernetes_alpha" {
  description = "Whether to enable Kubernetes Alpha features for this cluster."
  type = bool
  default = false
}

variable "enable_tpu" {
  description = "Whether to enable Cloud TPU in this cluster."
  type = bool
  default = false
}

variable "logging_service" {
  description = "The logging service for the cluster."
  type = string
  default = "logging.googleapis.com/kubernetes"
}

variable "maintenance_policy" {
  description = "The maintenance policy for the cluster"
  type = object({
    daily_maintenance_window = object({
      start_time = string
    })
  })
  default = {
    daily_maintenance_window = {
      start_time = "01:00"
    }
  }
}

variable "master_authorized_networks_config" {
  description = <<EOF
    The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access.
  EOF

  type = object({
    cidr_blocks = list(
    object({
      display_name = string
      cidr_block = string
    })
    )
  })

  default = {
    cidr_blocks = []
  }
}


variable "monitoring_service" {
  description = "The monitoring service for the cluster."
  default = "monitoring.googleapis.com/kubernetes"
}

variable "network_policy" {
  description = "The configuration for the NetworkPolicy features."
  type = object({
    provider = string
    enabled = bool
  })
  default = {
    provider = "PROVIDER_UNSPECIFIED"
    enabled = false
  }
}

variable "pod_security_policy_config" {
  description = "The configuration of the pod security policy."
  type = object({
    enabled = bool
  })
  default = {
    enabled = false
  }
}

variable "authenticator_groups_config" {
  description = <<EOF
    The Configuration for the Google Groups for GKE feature.
    This variable is supposed to be an object but I make it a list of the object in order to utilize dynamic blocks to generate the config.
    Please note that you should only contain ONE item in the list.
    ## Example Config ##
    authenticator_groups_config = [
      {
        security_group = "security_group_example"
      }
    ]
  EOF

  type = list(
    object({
      security_group = string
    })
  )
  default = []
}

variable "private_cluster_config" {
  description = "The confguration for creating a private cluster."
  type = object({
    enable_private_endpoint = bool
    enable_private_nodes = bool
    master_ipv4_cidr_block = string
  })
  default = {
    enable_private_endpoint = false
    enable_private_nodes = false
    master_ipv4_cidr_block = null
  }
}

variable "resource_labels" {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster."
  type = map(string)
  default = {}
}


variable "vertical_pod_autoscaling" {
  description = "The configuration of the Vertical Pod Autoscaling feature."
  type = object({
    enabled = bool
  })
  default = {
    enabled = false
  }
}

variable "workload_identity_config" {
  description = <<EOF
    The configuration for the workload identify, which allows Kubernetes service accounts to act as a user-managed Google IAM Service Account.
    This variable is supposed to be an object but I make it a list of the object in order to utilize dynamic blocks to generate the config.
    Please note that you should only contain ONE item in the list.
    ## Example Config ##
    workload_identity_config = [
      {
        identity_namespace = "identity_namespace_example"
      }
    ]
  EOF

  type = list(
    object({
      identity_namespace = string
    })
  )

  default = []
}

variable "enable_intranode_visibility" {
  description = "Wherther to enable intra node visibility for the cluster."
  default = false
}

//----------------------------------------------------------------------------------------------------------------------
// The following parameters are not recommeneded to be enabled based on the security consideration.
// Check [this doc](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster) for more details.
//----------------------------------------------------------------------------------------------------------------------

variable "kubernetes_dashboard" {
  description = "The configuration of the Kubernetes Dashboard addon."
  type = object({
    disabled = bool
  })
  default = {
    disabled = true
  }
}

variable "enable_legacy_abac" {
  description = "Whether to enable the ABAC authorizer in this cluster."
  type = bool
  default = false
}

variable "master_auth" {
  description = "The authentication information for accessing the Kubernetes master."
  type = object({
    username = string
    password = string
    issue_client_certificate = bool
  })
  default = {
    username = null   // Set username and password null to disable basic auth.
    password = null
    issue_client_certificate = false
  }
}
