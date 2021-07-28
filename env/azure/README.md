# VS Code Remote Development for Terraform azure

## Overview

This environment uses [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) and install Terraform/Azure CLI

## Required

- Visual Code Studio  
  https://code.visualstudio.com/download
- Docker  
  https://www.docker.com/

## Description

[VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) can use VS Code and Docker technology to create a Docker container from VS Code and enable work in the Docker container with VS Code.
If you have a base Docker image, you can complete all work with a Docker container without building an environment locally.
Since the base Docker Image has already been uploaded to [Docker Hub](https://hub.docker.com/) in this repository, it can be used immediately.

### Set devcontainer.json

Set devcontainer.json to use [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview).

```bash
$ cp -rp env/azure/template env/azure/{your environment}
$ cat env/azure/{your environment}/.devcontainer/devcontainer.json
{
  "image": "ghcr.io/y-miyazaki/terraform-azure:latest",
  "settings": {
    "terminal.integrated.defaultProfile.linux": "/bin/bash"
  },
  "extensions": [
    "hashicorp.terraform",
    "coenraads.bracket-pair-colorizer-2",
    "eamodio.gitlens",
    "editorconfig.editorconfig",
    "esbenp.prettier-vscode",
    "ibm.output-colorizer",
    "streetsidesoftware.code-spell-checker",
    "vscode-icons-team.vscode-icons",
  ],
  "build": {
    "args": {
      "WORKDIR": "/workspace"
    }
  },
  "runArgs": [
    "-v",
    "${env:HOME}/##YOUR_WORKSPACE##:/workspace",
    "--env-file=.env"
  ],
  "workspaceFolder": "/workspace",
  "overrideCommand": false
}
```

### change devcontainer.json

"##YOUR_WORKSPACE##" fix in devcontainer.json.

1. ##YOUR_WORKSPACE## is your local directory for volume mount. If you want to absolute directory, don't need to \${env:HOME} value.

```json
{
  "image": "ghcr.io/y-miyazaki/terraform-azure:latest",
  "extensions": [
    "hashicorp.terraform",
    "coenraads.bracket-pair-colorizer-2",
    "eamodio.gitlens",
    "editorconfig.editorconfig",
    "esbenp.prettier-vscode",
    "ibm.output-colorizer",
    "streetsidesoftware.code-spell-checker",
    "vscode-icons-team.vscode-icons"
  ],
  "build": {
    "args": {
      "WORKDIR": "/workspace"
    }
  },
  "runArgs": [
    "-v",
    "${env:HOME}/workspace/terraform-project:/workspace",
    "--env-file=.env"
  ],
  "workspaceFolder": "/workspace",
  "overrideCommand": false
}
```

### fix env/azure/{your environment}/.env.

By modifying .env, you can automatically log in to the cloud environment and automatically generate a terraform template for the provider.

```bash
$ cat env/azure/{your environment}/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV={development|staging|production..etc}

# terraform cache directory
TF_PLUGIN_CACHE_DIR=/workspace/.terraform.d/plugin-cache
#---------------------------------------------------------
# Install and configure Terraform to provision Azure resources
# https://docs.microsoft.com/azure/virtual-machines/linux/terraform-install-configure
#---------------------------------------------------------
# app_id used for az command and terraform
ARM_CLIENT_ID={set app_id from service principal}

# password used for az command and terraform
ARM_CLIENT_SECRET={set passowrd from service principal}

# tenant used for az command and terraform
# az account show --query "{subscriptionId:id, tenantId:tenantId}"
ARM_TENANT_ID={set tenant_id from service principal}

# subscription id used for az command and terraform
# az account show --query "{subscriptionId:id, tenantId:tenantId}"
ARM_SUBSCRIPTION_ID={set subscription_id from service principal}

#---------------------------------------------------------
# Store Terraform state in Azure Storage
# https://docs.microsoft.com/azure/terraform/terraform-backend
#---------------------------------------------------------
# Azure Storage Account Name for terraform state
STORAGE_ACCOUNT_NAME={storage account name}

# Azure Resource Group for terraform state
RESOURCE_GROUP_NAME={resource group name}

# Azure Container Name for terraform state
CONTAINER_NAME={container name}

# Azure Storage Account Access
# check console [Azure Storage Account -> Access Key Page]
# command)
# az storage account keys list --resource-group ${RESOURCE_GROUP_NAME} --account-name ${STORAGE_ACCOUNT_NAME}  --query [0].value -o tsv
ARM_ACCESS_KEY={storage account access key}
```

Here is example.

```bash
$ cat env/aws/{your environment}/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV=production

# terraform cache directory
TF_PLUGIN_CACHE_DIR=/workspace/.terraform.d/plugin-cache
#---------------------------------------------------------
# Install and configure Terraform to provision Azure resources
# https://docs.microsoft.com/azure/virtual-machines/linux/terraform-install-configure
#---------------------------------------------------------
# app_id used for az command and terraform
ARM_CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx

# password used for az command and terraform
ARM_CLIENT_SECRET=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx

# tenant used for az command and terraform
# az account show --query "{subscriptionId:id, tenantId:tenantId}"
ARM_TENANT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx

# subscription id used for az command and terraform
# az account show --query "{subscriptionId:id, tenantId:tenantId}"
ARM_SUBSCRIPTION_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx

#---------------------------------------------------------
# Store Terraform state in Azure Storage
# https://docs.microsoft.com/azure/terraform/terraform-backend
#---------------------------------------------------------
# Azure Storage Account Name for terraform state
STORAGE_ACCOUNT_NAME=xxxxxxxxxxxxxxxxxx

# Azure Resource Group for terraform state
RESOURCE_GROUP_NAME=tfstate-resource-group

# Azure Container Name for terraform state
CONTAINER_NAME=tfstate

# Azure Storage Account Access
# check console [Azure Storage Account -> Access Key Page]
# command)
# az storage account keys list --resource-group ${RESOURCE_GROUP_NAME} --account-name ${STORAGE_ACCOUNT_NAME}  --query [0].value -o tsv
ARM_ACCESS_KEY=xxxxxxxxxxxxx/xxxxxxxxx/xxxxxxxxxxxxxxxxxx==
```

## Other Link

- Docker  
  https://www.docker.com/
- Terraform  
  https://www.terraform.io/
- Azure CLI  
  https://docs.microsoft.com/ja-jp/cli/azure/?view=azure-cli-latest
- Azure Provider  
  https://www.terraform.io/docs/providers/azurerm/index.html
