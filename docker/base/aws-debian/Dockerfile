#--------------------------------------------------------------
# base build image
#--------------------------------------------------------------
FROM mcr.microsoft.com/vscode/devcontainers/go:1.17

#--------------------------------------------------------------
# ARG
#--------------------------------------------------------------
ARG WORKDIR=/workspace
ARG TERRAFORM_DOCS=0.16.0

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
    # Install docker
    curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh ./get-docker.sh && \
    rm -f get-docker.sh && \
    # setting commands
    curl -sSL https://raw.githubusercontent.com/y-miyazaki/cloud-commands/master/install.sh | sh -s && \
    # Install pre-commit
    pip3 install pre-commit --ignore-installed distlib && \
    # Install gitleaks
    curl -sLO https://github.com/zricethezav/gitleaks/releases/latest/download/gitleaks-linux-amd64 && \
    chmod +x gitleaks-linux-amd64 && \
    mv gitleaks-linux-amd64 /usr/local/bin/gitleaks && \
    # Install tfenv
    git clone https://github.com/kamatama41/tfenv.git ~/.tfenv && \
    ln -s ~/.tfenv/bin/* /usr/local/bin && \
    # Install tflint
    curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    # Install tfsec
    curl -sLO https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-amd64 && \
    chmod +x tfsec-linux-amd64 && \
    mv tfsec-linux-amd64 /usr/local/bin/tfsec && \
    # Install terraform-docs
    curl -OL https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS}/terraform-docs-v${TERRAFORM_DOCS}-linux-amd64.tar.gz && \
    mkdir terraform-docs && \
    tar -zxvf terraform-docs-v${TERRAFORM_DOCS}-linux-amd64.tar.gz -C ./terraform-docs && \
    mv terraform-docs/terraform-docs /usr/local/bin/terraform-docs && \
    chmod +x /usr/local/bin/terraform-docs && \
    rm -rf terraform-docs* && \
    # Install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

ENTRYPOINT []
CMD ["/usr/local/bin/awsdockercmd"]
