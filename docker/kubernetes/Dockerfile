#--------------------------------------------------------------
# base build image
#--------------------------------------------------------------
FROM mcr.microsoft.com/vscode/devcontainers/go:1.17

#--------------------------------------------------------------
# ARG
#--------------------------------------------------------------
ARG WORKDIR=/workspace

#--------------------------------------------------------------
# ENV
#--------------------------------------------------------------
# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

#--------------------------------------------------------------
# workdir
#--------------------------------------------------------------
RUN mkdir -p ${WORKDIR}
WORKDIR  ${WORKDIR}

#--------------------------------------------------------------
# Install dependent packages
#--------------------------------------------------------------
RUN apt update && \
    apt -y install make openssl git tar curl zip jq groff gcc npm bison python3 python3-dev python3-pip && \
    # Clean up
    rm -rf /tmp/tmp.* && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    # setting commands
    curl -sSL https://raw.githubusercontent.com/y-miyazaki/cloud-commands/master/install.sh | sh -s && \
    # Install pre-commit
    pip3 install pre-commit --ignore-installed distlib && \
    # Install gitleaks
    curl -sLO https://github.com/zricethezav/gitleaks/releases/latest/download/gitleaks-linux-amd64 && \
    chmod +x gitleaks-linux-amd64 && \
    mv gitleaks-linux-amd64 /usr/local/bin/gitleaks

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=
