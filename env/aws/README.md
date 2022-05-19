# VS Code Remote Development for Terraform AWS

## Overview

This environment uses [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) and install Terraform/AWS CLI

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
$ cp -rp env/aws/template env/aws/{your environment}
$ cat env/aws/{your environment}/.devcontainer/devcontainer.json
{
  "image": "ghcr.io/y-miyazaki/terraform-aws-debian:latest",
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
  "image": "ghcr.io/y-miyazaki/terraform-aws-debian:latest",
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

### fix env/aws/{your environment}/.env.

By modifying .env, you can automatically log in to the cloud environment and automatically generate a terraform template for the provider.

```bash
$ cat env/aws/{your environment}/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV={development|staging|production..etc}

# terraform cache directory
TF_PLUGIN_CACHE_DIR=/workspace/.terraform.d/plugin-cache
#---------------------------------------------------------
# aws setting
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
#---------------------------------------------------------
# AWS_ACCESS_KEY_ID uses for default profile.
AWS_ACCESS_KEY_ID={aws access key}

# AWS_SECRET_ACCESS_KEY uses for default profile.
AWS_SECRET_ACCESS_KEY={aws secret key}

# AWS_DEFAULT_REGION uses for default profile.
AWS_DEFAULT_REGION={aws default region}

# AWS_REGION uses for default profile.
AWS_REGION={aws default region}
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
# aws setting
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
#---------------------------------------------------------
# AWS_ACCESS_KEY_ID uses for default profile.
AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxxxxxx

# AWS_SECRET_ACCESS_KEY uses for default profile.
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxx

# AWS_DEFAULT_REGION uses for default profile.
AWS_DEFAULT_REGION=ap-northeast-1

# AWS_REGION uses for default profile.
AWS_REGION=ap-northeast-1
```

## Other Link

- Docker  
  https://www.docker.com/
- Terraform  
  https://www.terraform.io/
- AWS CLI  
  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
- AWS Provider  
  https://www.terraform.io/docs/providers/aws/index.html
