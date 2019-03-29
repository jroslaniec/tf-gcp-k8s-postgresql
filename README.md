# PostgreSQL Terraform module

This module is to deploy [PostgreSQL](https://www.postgresql.org/) in k8s cluster on GCP.

Module uses [stable/postgresql](https://github.com/helm/charts/tree/master/stable/postgresql) chart.

## Configuration

Override default settings by providing `values.yaml` file.
For list of available settings see [stable/postgresql](https://github.com/helm/charts/tree/master/stable/postgresql#configuration)
