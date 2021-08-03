# Docker for Terraform Providers

## Overview

Docker is used as the environment for running Terraform. We manage the Dockerfile for this and upload it to the Github Container Registry.
Docker images in the Github Container Registry can be used as build and development environments.

## Description for Docker Image

- [ghcr.io/y-miyazaki/terraform-aws](https://github.com/y-miyazaki/docker-terraform/pkgs/container/terraform-aws)  
  Mainly pre-commit/gitleaks/tfenv/terraform/tfsec/tflint/aws commands are installed.
- [ghcr.io/y-miyazaki/terraform-gcp](https://github.com/y-miyazaki/docker-terraform/pkgs/container/terraform-gcp)  
  Mainly pre-commit/gitleaks/tfenv/terraform/tfsec/tflint/gcloud commands are installed.
- [ghcr.io/y-miyazaki/terraform-azure](https://github.com/y-miyazaki/docker-terraform/pkgs/container/terraform-azure)  
  Mainly pre-commit/gitleaks/tfenv/terraform/tfsec/tflint/az commands are installed.
- [ghcr.io/y-miyazaki/terraform-github](https://github.com/y-miyazaki/docker-terraform/pkgs/container/terraform-github)  
  Mainly pre-commit/gitleaks/tfenv/terraform/tfsec/tflint commands are installed.

## Description for VSCode Remote Development

Below we share links to README.md for each environment.
Please check the content of the link because the setting contents differ for each Terraform Provider.

- [AWS](env/aws/README.md)  
  A document that describes how to configure the environment of [AWS Provider](https://www.terraform.io/docs/providers/aws/index.html).
- [GCP](env/gcp/README.md)  
  A document that describes how to configure the environment of [Google Cloud Platform Provider](https://www.terraform.io/docs/providers/google/index.html).
- [Azure](env/azure/README.md)  
  A document that describes how to configure the environment of [Azure Provider](https://www.terraform.io/docs/providers/azurerm/index.html).
- [Github](env/github/README.md)  
  A document that describes how to configure the environment of [GitHub Provider](https://www.terraform.io/docs/providers/github/index.html).

## About terraform version management

On the Docker image, you can install and use Go by specifying the version with the tfenv command already installed.

```bash
$ tfenv install x.x.x
$ tfenv use
```
