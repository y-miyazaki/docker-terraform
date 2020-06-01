# VS Code Remote Development for Terraform(GitHub)

## Overview

This environment uses [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) and install Terraform for GitHub Provider.

## Description

[VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) can use VS Code and Docker technology to create a Docker container from VS Code and enable work in the Docker container with VS Code.  
If you have a base Docker image, you can complete all work with a Docker container without building an environment locally.  
Since the base Docker Image has already been uploaded to [Docker Hub](https://hub.docker.com/) in this repository, it can be used immediately.

### Set devcontainer.json

Set devcontainer.json to use [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview).

```bash
$ cp -rp env/github/template env/github/{your environment}
$ cat env/github/{your environment}/.devcontainer/devcontainer.json
{
  "image": "registry.hub.docker.com/ymiyazakixyz/terraform-github:latest",
  "settings": {
    "terminal.integrated.shell.linux": "/bin/bash"
  },
  "extensions": [
    "mauve.terraform",
    "coenraads.bracket-pair-colorizer-2",
    "eamodio.gitlens",
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
  "image": "registry.hub.docker.com/ymiyazakixyz/terraform-github:latest",
  "settings": {
    "terminal.integrated.shell.linux": "/bin/bash"
  },
  "extensions": [
    "mauve.terraform",
    "coenraads.bracket-pair-colorizer-2",
    "eamodio.gitlens",
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

### fix env/github/{your environment}/.env.

By modifying .env, you can automatically log in to the cloud environment and automatically generate a terraform template for the provider.

```bash
$ cat env/github/{your environment}/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV={development|staging|production..etc}

# IS_GENERATE_PROVIDER generates main_init.tf for terraform and provider and github's data resources.
# When IS_GENERATE_PROVIDER is equal to 1, created main_init.tf under workspace directory.
IS_GENERATE_PROVIDER={0|1}

#---------------------------------------------------------
# see
# https://www.terraform.io/docs/configuration/resources.html
#---------------------------------------------------------
# token - (Optional) This is the GitHub personal access token. It can also be sourced from the GITHUB_TOKEN environment variable. If anonymous is false, token is required.
GITHUB_TOKEN={set github token}

# organization - (Optional) This is the target GitHub organization to manage. The account corresponding to the token will need "owner" privileges for this organization. It can also be sourced from the GITHUB_ORGANIZATION environment variable. If individual is set to false, organization is required.
GITHUB_ORGANIZATION={set github organization}

# individual: (Optional) Run outside an organization. When individual is true, the provider will run outside the scope of an organization. Defaults to false.
GITHUB_INDIVIDUAL={set individual}
```

Here is example.

```bash
$ cat env/github/{your environment}/.env
#---------------------------------------------------------
# base
#---------------------------------------------------------
# ENV uses terraform.${ENV}.tfvars file etc...
ENV=production

# IS_GENERATE_PROVIDER generates main_init.tf for terraform and provider and github's data resources.
# When IS_GENERATE_PROVIDER is equal to 1, created main_init.tf under workspace directory.
IS_GENERATE_PROVIDER=1

#---------------------------------------------------------
# see
# https://www.terraform.io/docs/configuration/resources.html
#---------------------------------------------------------
# token - (Optional) This is the GitHub personal access token. It can also be sourced from the GITHUB_TOKEN environment variable. If anonymous is false, token is required.
GITHUB_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# organization - (Optional) This is the target GitHub organization to manage. The account corresponding to the token will need "owner" privileges for this organization. It can also be sourced from the GITHUB_ORGANIZATION environment variable. If individual is set to false, organization is required.
GITHUB_ORGANIZATION=

# individual: (Optional) Run outside an organization. When individual is true, the provider will run outside the scope of an organization. Defaults to false.
GITHUB_INDIVIDUAL=true
```

### terraform version(latest)

```bash
bash-5.0# terraform -v
Terraform v0.12.25
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
- GitHub Provider  
  https://www.terraform.io/docs/providers/github/index.html

## Note
