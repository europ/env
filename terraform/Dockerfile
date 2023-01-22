# https://hub.docker.com/_/oraclelinux
FROM oraclelinux:8

# buildtime variables
ARG USERNAME=terraform
ARG USERGROUP=${USERNAME}
ARG USERID=1000
ARG GROUPID=1000

# https://docs.docker.com/build/buildkit/
# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM
RUN echo "TARGETPLATFORM=${TARGETPLATFORM}"

# update packages
RUN dnf update -y

# install packages
RUN dnf install -y \
        unzip \
        sudo \
        git

# install OCI CLI (including OCI SDK)
# https://github.com/oracle/oci-cli#installation
RUN bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" \
        bash \
            --accept-all-defaults \
            --install-dir /opt/oci-cli \
            --exec-dir /usr/local/bin \
            && \
    exec -l $SHELL && \
    oci --version

# install Terraform
# https://www.terraform.io/downloads.html
RUN if test "$TARGETPLATFORM" = "linux/arm64"; then \
        TERRAFORM_ARCH=arm64; \
    else \
        TERRAFORM_ARCH=amd64; \
    fi && \
    curl \
        -o /tmp/terraform.zip \
        https://releases.hashicorp.com/terraform/1.2.9/terraform_1.2.9_linux_${TERRAFORM_ARCH}.zip && \
    unzip -o /tmp/terraform.zip terraform -d /usr/local/bin && \
    chmod +x /usr/local/bin/terraform && \
    terraform -v && \
    ln -s /usr/local/bin/terraform /usr/local/bin/tf && \
    tf -v

# install Terragrunt
# https://terragrunt.gruntwork.io/docs/getting-started/install/
RUN if test "$TARGETPLATFORM" = "linux/arm64"; then \
        TERRAGRUNT_ARCHITECTURE=arm64; \
    else \
        TERRAGRUNT_ARCHITECTURE=amd64; \
    fi && \
    curl -o /usr/local/bin/terragrunt -L \
        "${GITHUB_TOKEN_CURL_AUTH_HEADER[@]}" \
        https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.12/terragrunt_linux_${TERRAGRUNT_ARCHITECTURE} && \
    chmod +x /usr/local/bin/terragrunt && \
    terragrunt -v && \
    ln -s /usr/local/bin/terragrunt /usr/local/bin/tg && \
    tg -v

# install kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
RUN if test "$TARGETPLATFORM" = "linux/arm64"; then \
        KUBECTL_ARCH=arm64; \
    else \
        KUBECTL_ARCH=amd64; \
    fi && \
    curl -o /usr/local/bin/kubectl -L https://dl.k8s.io/release/v1.20.15/bin/linux/${KUBECTL_ARCH}/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --client

# create user
RUN groupadd ${USERGROUP} -g ${GROUPID} \
    && useradd ${USERNAME} -u ${USERID} -g ${GROUPID} -m -s /bin/bash

# enable sudo for non-root user
RUN usermod -a -G wheel ${USERNAME} \
    && echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

# become non-root user
USER ${USERNAME}
