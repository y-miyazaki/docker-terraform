# VS Code Remote Development for Google Cloud Platform Provider

## Overview

This environment uses [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) for [Google Cloud Platform](https://console.cloud.google.com/).

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
$ cp -rp env/gcp/template env/gcp/{your environment}
$ cat env/gcp/{your environment}/.devcontainer/devcontainer.json
{
  "image": "ghcr.io/y-miyazaki/terraform-gcp:latest",
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
    "-v",
    "##YOUR_KEY_FILE_DIRECTORY##:/env/",
    "--env-file=.env"
  ],
  "workspaceFolder": "/workspace",
  "overrideCommand": false
}
```

### change devcontainer.json

"##YOUR_WORKSPACE##" and ##YOUR_KEY_FILE_DIRECTORY## fix in devcontainer.json.

- ##YOUR_WORKSPACE## is your local directory for volume mount. If you want to absolute directory, don't need to \${env:HOME} value.
- ##YOUR_KEY_FILE_DIRECTORY## is your .key file directory for volume mount. If you want to absolute directory.

```json
{
  "image": "ghcr.io/y-miyazaki/terraform-gcp:latest",
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
    "-v",
    "${env:HOME}/workspace/docker-terraform/env/gcp/production/:/env/",
    "--env-file=.env"
  ],
  "workspaceFolder": "/workspace",
  "overrideCommand": false
}
```

### fix env/gcp/{your environment}/.env.

By modifying .env, you can automatically log in to the cloud environment and automatically generate a terraform template for the provider.

```bash
$ cat env/gcp/{your environment}/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV={development|staging|production..etc}

# terraform cache directory
TF_PLUGIN_CACHE_DIR=/workspace/.terraform.d/plugin-cache
#---------------------------------------------------------
# Google Cloud Platform Provider
# https://www.terraform.io/docs/providers/google/index.html
#---------------------------------------------------------
# default project id gcloud command and terraform
PROJECT_ID={gcp project id}

# default region uses gcloud command and terraform
REGION={gcp main region}

# default zone uses gcloud command and terraform
ZONE={gcp main region zone}

# GOOGLE_CLOUD_KEYFILE_JSON uses gcloud auth command and init provider.
GOOGLE_CLOUD_KEYFILE_JSON=/env/.key
```

Here is example.

```bash
$ cat env/aws/{your environment}/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV=production

#---------------------------------------------------------
# Google Cloud Platform Provider
# https://www.terraform.io/docs/providers/google/index.html
#---------------------------------------------------------
# default project id gcloud command and terraform
PROJECT_ID=xxxxxxxxxx

# default region uses gcloud command and terraform
REGION=us-west-1

# default zone uses gcloud command and terraform
ZONE=us-west-1

# GOOGLE_CLOUD_KEYFILE_JSON uses gcloud auth command and init provider.
GOOGLE_CLOUD_KEYFILE_JSON=/env/.key
```

### fix env/{environment}/.key.

You need to fix .key file.
This file is Service Account Key json. Please check this following page.
https://cloud.google.com/iam/docs/creating-managing-service-account-keys

Here is example.

```json
$ cat env/template/.key
{
"type": "****************",
"project_id": "[PROJECT-ID]",
"private_key_id": "[KEY-ID]",
"private_key": "****************",
"client_email": "[SERVICE-ACCOUNT-EMAIL]",
"client_id": "[CLIENT-ID]",
"auth_uri": "https://accounts.google.com/o/oauth2/auth",
"token_uri": "https://accounts.google.com/o/oauth2/token",
"auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
"client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/[SERVICE-ACCOUNT-EMAIL]"
}
```

## Other Link

- Docker  
  https://www.docker.com/
- Terraform  
  https://www.terraform.io/
- Google Cloud SDK  
  https://cloud.google.com/sdk/downloads
- Google Cloud Platform Provider  
  https://www.terraform.io/docs/providers/google/index.html
