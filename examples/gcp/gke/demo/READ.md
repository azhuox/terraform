# GKE Cluster Demo

This demo demonstrates how to use the [cluster] and [node pool] module to create a GKE cluster with two node pools.

## How to Run This Demo

1. Make sure you are in the `examples/gcp/gke/demo` folder: `cd examples/gcp/gke/demo`
2. Initialize terraform: `terraform init`
3. Modify the variables in the [variables.tf](https://github.com/azhuox/terraform/blob/master/examples/gcp/gke/demo/variables.tf) file 
4. Check the terraform plan: `terraform plan`
5. Apply the terraform code to create the cluster: `terraform apply`
6. Destroy the cluster: `terraform destroy`
