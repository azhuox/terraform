# GKE Cluster Terraform Module

This modules allows you to create GKE clusters. All the configurable parameters are "templated" using variables in the [variables.tf](https://github.com/azhuox/terraform/blob/master/modules/gcp/gke/cluster/variables.tf). The details of these parameters can be found [this doc](https://www.terraform.io/docs/providers/google/r/container_cluster.html) file.

Please note that his module will not create any node pool. But you can use the [node pool](https://github.com/azhuox/terraform/tree/master/modules/gcp/gke/node-pool) module to do that.

## Example

An example of utilizing this module can be found in [this folder](https://github.com/azhuox/terraform/tree/master/examples/gcp/gke/demo).

