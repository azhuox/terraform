output "name" {
  // This may seem redundant with the `name` input, but it serves an important
  // purpose. Terraform won't establish a dependency graph without this to interpolate on.
  description = "The name of the cluster master which is used for interpolation with node pools and other modules."
  value = google_container_cluster.primary.name
}

