#--------------------------------------------------------------
# base build image
#--------------------------------------------------------------
ARG TERRAFORM_VERSION=latest
FROM hashicorp/terraform:${TERRAFORM_VERSION}

#--------------------------------------------------------------
# ARG
#--------------------------------------------------------------
ARG WORKDIR=/workspace
ARG CLOUD_COMMANDS_VERSION

#--------------------------------------------------------------
# ENV
#--------------------------------------------------------------
ENV CLOUDSDK_PYTHON=python3

#--------------------------------------------------------------
# workdir
#--------------------------------------------------------------
RUN mkdir -p ${WORKDIR}
WORKDIR  ${WORKDIR}

#--------------------------------------------------------------
# Install dependent packages
#--------------------------------------------------------------
RUN apk update && \
    apk add --no-cache make bash tar curl zip openssl jq sudo python3 python3-dev py3-pip && \
    # Install pre-commit
    pip3 install pre-commit && \
    # tflint
    curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    # tfsec
    curl -sLO https://github.com/tfsec/tfsec/releases/download/$(curl -s https://api.github.com/repos/tfsec/tfsec/releases/latest | grep tag_name | cut -d '"' -f 4)/tfsec-linux-amd64 && \
    chmod +x tfsec-linux-amd64 && \
    sudo mv tfsec-linux-amd64 /usr/local/bin/tfsec && \
    # setting commands
    curl -sSfL https://raw.githubusercontent.com/y-miyazaki/cloud-commands/master/install.sh | sh -s -- ${CLOUD_COMMANDS_VERSION} && \
    # Install Google Cloud SDK
    curl https://sdk.cloud.google.com | bash && \
    $SHELL && \
    echo "source /root/google-cloud-sdk/path.bash.inc" >> $HOME/.bashrc && \
    echo "source /root/google-cloud-sdk/completion.bash.inc" >> $HOME/.bashrc

ENTRYPOINT []
CMD ["/usr/local/bin/gcpdockercmd"]
