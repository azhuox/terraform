# Terraform

This repo contains some reusable terraform modules which allow you to easily create a single piece of infrastructure, for example, a Kubernetes cluster, through terraform.

## What Is in This Repo

This repo includes the following folders:

* [modules](https://github.com/azhuox/terraform/tree/master/modules) : This folder contains reusable terraform modules. These modules are basically configuration templates creating & managing your infrastructures, such as Google Container Engine (GKE) K8s Clusters and node pools. You can check each module's README for more details.

* [examples](https://github.com/azhuox/terraform/tree/master/examples): This folder contains examples of how to use the modules defined in the `modules` folder.

## Prerequisites

All the modules in this repo require terraform >= 0.12. You can go to [this page](https://www.terraform.io/downloads.html) for downloading & installing terraform or check [this doc](https://www.terraform.io/upgrade-guides/0-12.html) for details about how to upgrade terraform to 0.12.

