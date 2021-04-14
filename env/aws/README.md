# VS Code Remote Development for Terraform AWS

## Overview

This environment uses [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) and install Terraform/AWS CLI

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
  "image": "registry.hub.docker.com/ymiyazakixyz/terraform-aws:latest",
  "settings": {
    "terraform.lintPath": "/usr/local/bin/tflint",
    "terminal.integrated.shell.linux": "/bin/bash"
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
  "image": "registry.hub.docker.com/ymiyazakixyz/terraform-aws:latest",
  "settings": {
    "terraform.lintPath": "/usr/local/bin/tflint",
    "terminal.integrated.shell.linux": "/bin/bash"
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

# IS_GENERATE_PROVIDER generates main_init.tf for terraform and provider and aws's data resources.
# When IS_GENERATE_PROVIDER is equal to 1, created main_init.tf under workspace directory.
IS_GENERATE_PROVIDER={0|1}

# terraform cache directory
TF_PLUGIN_CACHE_DIR=/root/.terraform.d/plugin-cache
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

#---------------------------------------------------------
# Store Terraform state in S3
# https://www.terraform.io/docs/backends/types/s3.html
#---------------------------------------------------------
# terraform state s3 bucket name.
BUCKET={s3 terraform state bucket}
```

Here is example.

```bash
$ cat env/aws/{your environment}/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV=production

# IS_GENERATE_PROVIDER generates main_init.tf for terraform and provider and aws's data resources.
# When IS_GENERATE_PROVIDER is equal to 1, created main_init.tf under workspace directory.
IS_GENERATE_PROVIDER=1

# terraform cache directory
TF_PLUGIN_CACHE_DIR=/root/.terraform.d/plugin-cache
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

#---------------------------------------------------------
# Store Terraform state in S3
# https://www.terraform.io/docs/backends/types/s3.html
#---------------------------------------------------------
# terraform state s3 bucket name.
BUCKET=terraform-state
```

## awstf plan(terraform plan)

if you set "IS_GENERATE_PROVIDER=1", this following command generates main_init.tf under current directory and action terraform plan.
main_init.tf is created by tf command.

```bash
$ awstf plan
Initializing modules...

Initializing the backend...

Initializing provider plugins...

・・・・・・・・・・・・・・・・・・・・・・・・

------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.

$ cat main_init.tf
#--------------------------------------------------------------
# main_init.tf must be not touch! because main_init.tf is auto generate file.
# If you want to fix it, you should be fix shell/aws/files/main.template.tf.
#--------------------------------------------------------------

#--------------------------------------------------------------
# terraform state
#--------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket  = "xxxxxx-terraform-state-xxxxxxxxx"
    key     = "terraform.tfstate"
    profile = "default"    # fix for environment
    region  = "ap-northeast-1" # fix for environment
  }
}

#--------------------------------------------------------------
# Provider Setting
# access key and secret key should not use.
#--------------------------------------------------------------
provider "aws" {
  profile = "default"    # fix for environment
  region  = "ap-northeast-1" # fix for environment
}

#--------------------------------------------------------------
# my account id/region
#--------------------------------------------------------------
data "aws_caller_identity" "self" {}
data "aws_region" "self" {}
```

## awstf apply(terraform apply)

if you set "IS_GENERATE_PROVIDER=1", this following command generates main_init.tf under current directory and action terraform apply.
main_init.tf is created by tf command.

```bash
$ awstf apply
Initializing modules...

Initializing the backend...

Initializing provider plugins...

・・・・・・・・・・・・・・・・・・・・・・・・

------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
$ cat main_init.tf
#--------------------------------------------------------------
# main_init.tf must be not touch! because main_init.tf is auto generate file.
# If you want to fix it, you should be fix shell/aws/files/main.template.tf.
#--------------------------------------------------------------

#--------------------------------------------------------------
# terraform state
#--------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket  = "xxxxxx-terraform-state-xxxxxxxxx"
    key     = "terraform.tfstate"
    profile = "default"    # fix for environment
    region  = "ap-northeast-1" # fix for environment
  }
}

#--------------------------------------------------------------
# Provider Setting
# access key and secret key should not use.
#--------------------------------------------------------------
provider "aws" {
  profile = "default"    # fix for environment
  region  = "ap-northeast-1" # fix for environment
}

#--------------------------------------------------------------
# my account id/region
#--------------------------------------------------------------
data "aws_caller_identity" "self" {}
data "aws_region" "self" {}
```

### terraform version(latest)

```bash
bash-5.0# terraform -v
Terraform v0.12.25
```

### aws version

```
bash-5.0# aws --v
aws-cli/2.0.9 Python/3.7.3 Linux/4.19.76-linuxkit botocore/2.0.0dev13
```

## Required

- Visual Code Studio  
  https://code.visualstudio.com/download
- Docker  
  https://www.docker.com/

## Other Link

- Docker  
  https://www.docker.com/
- Terraform  
  https://www.terraform.io/
- AWS CLI  
  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
- AWS Provider  
  https://www.terraform.io/docs/providers/aws/index.html

## Note
