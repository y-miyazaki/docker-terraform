#--------------------------------------------------------------
# base build image
#--------------------------------------------------------------
# ARG TERRAFORM_VERSION=latest
# FROM hashicorp/terraform:${TERRAFORM_VERSION}
FROM alpine:latest

#--------------------------------------------------------------
# ARG
#--------------------------------------------------------------
ARG WORKDIR=/workspace
ARG CLOUD_COMMANDS_VERSION=v0.7.1
ARG GLIBC_VER=2.31-r0

#--------------------------------------------------------------
# workdir
#--------------------------------------------------------------
RUN mkdir -p ${WORKDIR}
WORKDIR  ${WORKDIR}

#--------------------------------------------------------------
# Install dependent packages
#--------------------------------------------------------------
RUN apk update && \
    apk add --no-cache make bash git tar curl zip openssl jq sudo python3 python3-dev py3-pip && \
    # fix sudo: setrlimit(RLIMIT_CORE): Operation not permitted
    echo "Set disable_coredump false" >> /etc/sudo.conf && \
    # Install pre-commit
    pip3 install pre-commit --ignore-installed distlib && \
    # Install tfenv
    git clone https://github.com/kamatama41/tfenv.git ~/.tfenv && \
    echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile && \
    source ~/.bash_profile && \
    # Install tflint
    curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    # Install tfsec
    curl -sLO https://github.com/tfsec/tfsec/releases/download/$(curl -s https://api.github.com/repos/tfsec/tfsec/releases/latest | grep tag_name | cut -d '"' -f 4)/tfsec-linux-amd64 && \
    chmod +x tfsec-linux-amd64 && \
    sudo mv tfsec-linux-amd64 /usr/local/bin/tfsec && \
    # setting commands
    curl -sSfL https://raw.githubusercontent.com/y-miyazaki/cloud-commands/master/install.sh | sh -s -- ${CLOUD_COMMANDS_VERSION} && \
    # install glibc compatibility for alpine(need to add it for AWS CLI)
    apk --no-cache add binutils && \
    curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk && \
    curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk && \
    # Install AWS CLI
    apk add --no-cache glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    rm -rf awscliv2.zip aws && \
    bash -c 'echo complete -C '/usr/local/bin/aws_completer' aws  >> $HOME/.bashrc' && \
    # remove glibc files.
    apk --no-cache del binutils && \
    rm glibc-${GLIBC_VER}.apk && \
    rm glibc-bin-${GLIBC_VER}.apk

ENTRYPOINT []
CMD ["/usr/local/bin/awsdockercmd"]
