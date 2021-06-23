#--------------------------------------------------------------
# base build image
#--------------------------------------------------------------
FROM alpine:3.14.0

#--------------------------------------------------------------
# ARG
#--------------------------------------------------------------
ARG WORKDIR=/workspace
ARG CLOUD_COMMANDS_VERSION=v0.7.1

#--------------------------------------------------------------
# workdir
#--------------------------------------------------------------
RUN mkdir -p ${WORKDIR}
WORKDIR  ${WORKDIR}

#--------------------------------------------------------------
# Install dependent packages
#--------------------------------------------------------------
RUN apk update && \
    apk add --no-cache make bash openssh git tar curl zip openssl jq python3 python3-dev py3-pip && \
    # setting commands
    curl -sSfL https://raw.githubusercontent.com/y-miyazaki/cloud-commands/master/install.sh | sh -s -- ${CLOUD_COMMANDS_VERSION} && \
    # Install pre-commit
    pip3 install pre-commit --ignore-installed distlib && \
    # Install gitleaks
    curl -sLO https://github.com/zricethezav/gitleaks/releases/download/$(curl -s https://api.github.com/repos/zricethezav/gitleaks/releases/latest | grep tag_name | cut -d '"' -f 4)/gitleaks-linux-amd64 && \
    chmod +x gitleaks-linux-amd64 && \
    mv gitleaks-linux-amd64 /usr/local/bin/gitleaks && \
    # Install tfenv
    git clone https://github.com/kamatama41/tfenv.git ~/.tfenv && \
    ln -s ~/.tfenv/bin/* /usr/local/bin && \
    # Install tflint
    curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    # Install tfsec
    curl -sLO https://github.com/tfsec/tfsec/releases/download/$(curl -s https://api.github.com/repos/tfsec/tfsec/releases/latest | grep tag_name | cut -d '"' -f 4)/tfsec-linux-amd64 && \
    chmod +x tfsec-linux-amd64 && \
    mv tfsec-linux-amd64 /usr/local/bin/tfsec

ENTRYPOINT []
CMD ["/usr/local/bin/githubdockercmd"]
