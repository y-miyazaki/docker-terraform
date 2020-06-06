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
# workdir
#--------------------------------------------------------------
RUN mkdir -p ${WORKDIR}
WORKDIR  ${WORKDIR}

#--------------------------------------------------------------
# Install dependent packages
#--------------------------------------------------------------
RUN apk update && \
    apk add --no-cache make bash tar curl zip openssl sudo py-pip && \
    # setting commands
    curl -sSfL https://raw.githubusercontent.com/y-miyazaki/cloud-commands/master/install.sh | sh -s -- ${CLOUD_COMMANDS_VERSION} && \
    # Install az command
    apk add --no-cache python3-dev && \
    apk add --no-cache --virtual=build gcc libffi-dev musl-dev openssl-dev  && \
    pip3 --no-cache-dir install -U pip && \
    pip3 --no-cache-dir install mock==4.0.2 && \
    pip3 --no-cache-dir install azure-cli && \
    apk del --purge build

ENTRYPOINT []
CMD ["/usr/local/bin/azdockercmd"]
