// ---------------------------------------------------------------------------------------------------------------------
// SHARED PARAMETERS
// You need to fill these parameters by initializing their default values.
// ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  description = "The project ID where all resources will be launched."
  type        = string
  default = "your-gcp-project-id"
}

variable "cluster_name" {
  description = "The name of the cluster that you are going to create."
  type        = string
  default = "cluster-name"
}

variable "location" {
  description = "The location (region or zone) of the GKE cluster."
  type        = string
  default = "us-central1"
}

