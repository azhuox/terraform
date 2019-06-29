# GKE Node Pool Terraform Module

This modules allows you to create GKE node pools. All the configurable parameters are "templated" using variables in the [variables.tf](https://github.com/azhuox/terraform/blob/master/modules/gcp/gke/cluster/variables.tf). The details of these parameters can be found [this doc](https://www.terraform.io/docs/providers/google/r/container_cluster.html) file.

Please note that you need to create a GKE cluster before using this module. Check the [cluster](https://www.terraform.io/docs/providers/google/r/container_node_pool.html) module for the details about how to use terraform to create GKE clusters.

## Example

An example of utilizing this module can be found in [this folder](https://github.com/azhuox/terraform/tree/master/examples/gcp/gke/demo).

