//----------------------------------------------------------------------------------------------------------------------
// Required parameters
//----------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The ID of the project in which the node pool belongs."
  type = string
}

variable "cluster_name" {
  description = "The name of the cluster in which the node pool belongs"
  type = string
}

variable "name" {
  description = "The name of the node pool."
  type = string
}

variable "location" {
  description = "The location (region or zone) in which the cluster resides."
  type = string
}

//----------------------------------------------------------------------------------------------------------------------
// Optional parameters
// These parameters have default values and they can be overriden based on your need.
//----------------------------------------------------------------------------------------------------------------------

variable "initial_node_count" {
  description = "The initial node count PER ZONE for the pool. The node pool will be recreated when you change this field."
  type = number
  default = 1
}

variable "node_count" {
    description = <<EOF
      The number of nodes per instance group in the node pool.
      You should not use this field alongside the autoscaling setting as it conflicts with the `autoscaling` field.
      This field is disabled by default. In order to enable it, you need to set `autoscaling = []` and
      set `node_count = count_number`.
    EOF
  type = number
  default = null  // Set to null to ommit this field.
}

variable "autoscaling" {
  description = <<EOF
    The configuration for the autoscaling feature for the node pool.
    This field is supposed to be an object but I convert it to a list (with only ONE item) in order to solve the conflict
    between this field with `node_count`.
    This field is enabled by default.
    ## Example ##
    autoscaling = [
      {
        min_node_count = 1  // Per zone
        max_node_count = 2  // Per zone
      },
    ]
  EOF
  type = list(
    object({
      min_node_count = number   // Per zone
      max_node_count = number   // Per zone
    })
  )
  default = [
    {
      min_node_count = 1
      max_node_count = 2
    }
  ]
}

variable "gke_version" {
  description = <<EOF
    The Kubernetes version for the nodes in this node pool.
    You should not set this field and the `management.auto_upgrade` field at the same time as they will fight each other.
    This field is disabled by default. In order ot enabled it, you need to set `management.auto_upgrade = false` and
    set `gke_version = <a_gke_version or latest>`
  EOF
  type = string
  default = null  // Set to null to ommit this field.
}

variable "management" {
  description = "The configuration about node management."
  type = object({
    auto_repair = bool
    auto_upgrade = bool
  })
  default = {
    auto_repair = true
    auto_upgrade = true
  }
}

variable "max_pods_per_node" {
  description = "The maximum number of pods per node in this node pool. The default value is 110."
  default = 110
}

variable "timeouts" {
  description = "The configuration about timeouts."
  type = object({
    create = string
    update = string
    delete = string
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

//--------------------------------------------------------------------------------
// Node config block
//
variable "disk_size_gb" {
  description = "The size (GB) of the disk attached to each node. The smallest legal disk size is 10GB."
  default = 20
}

variable "disk_type" {
  description = "The type of the disk attached to each node."
  default = "pd-standard"
}

variable "guest_accelerator" {
  description = "The list of the rype and cound of accelerator cards attached to node pool."
  type = list(object({
    type = string
    count = number
  }))
  default = []
}

variable "image_type" {
  description = "The image (OS) type to use for the nodes in this pool."
  type = string
  default = "COS" // Container Optimized OS
}

variable "labels" {
  description = "The K8s labels (key/value pairs) to be applied to each node in this pool."
  type = map(string)
  default = {}
}

variable "local_ssd_count" {
  description = "The number of local SSD disks per node."
  type = number
  default = 0
}

variable "machine_type" {
  description = "The name of a Ggoogle Compute Engine machine type that each node is going to use."
  type = string
  default = "n1-standard-1"
}


variable "metadata" {
  description = "The metadata (key/values) to be applied to each node in this pool."
  type = object({
    disable-legacy-endpoints = bool
  })
  default = {
    disable-legacy-endpoints = true
  }
}

variable "min_cpu_platform" {
  description = <<EOF
    The minimum CPU platform to be used in this node pool.
    Please check [this doc](https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform) for more details.
  EOF
  type = string
  default = "Intel Broadwell"
}

variable "oauth_scopes" {
  description = "The set of Google API scopes for all the node VMs under the `default` service account."
  type = list(string)
  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

variable "preemptible" {
  description = "Whther to use preemptiable VMs to run all then nodes in this pool."
  type = bool
  default = false
}

variable "service_account" {
  description = "The service account to be used by the Node VMs in this pool."
  type = string
  default = "default"
}

variable "tags" {
  description = "The list of instance tags applied to each node in this pool."
  type = list(string)
  default = []
}

variable "taints" {
  description = <<EOF
    The list of K8s taints to be applied to each node.
    You can check [this doc](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) for more details.
  EOF
  type = list(object({
    key = string
    value = string
    effect = string
  }))
  default = []
}

variable "workload_metadata_config" {
  description = "The metadata configuration to expose to workloads on the node pool"
  type = object({
    node_metadata = string
  })
  default = {
    node_metadata = "UNSPECIFIED"
  }
}
//--------------------------------------------------------------------------------
