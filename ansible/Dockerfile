# https://hub.docker.com/_/oraclelinux
FROM oraclelinux:8

# buildtime variables
ARG USERNAME=ansible
ARG USERGROUP=${USERNAME}
ARG USERID=1000
ARG GROUPID=1000

# update system packages
RUN dnf update -y

# install dependencies
RUN dnf install -y \
        git \
        python39 \
        python39-pip \
        python39-setuptools \
        sudo

# install ansible
RUN python3.9 -m pip install \
        ansible==7.1.0 \
        ansible-lint==6.10.2 \
        oci==2.90.0

# create user
RUN groupadd ${USERGROUP} -g ${GROUPID} \
    && useradd ${USERNAME} -u ${USERID} -g ${GROUPID} -m -s /bin/bash

# enable sudo for non-root user
RUN usermod -a -G wheel ${USERNAME} \
    && echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

# add ansible collection dependencies
COPY ./src/collections/requirements.yml /tmp/collections/requirements.yml

# install ansible collection dependencies
RUN ansible-galaxy collection install -r /tmp/collections/requirements.yml \
    && rm -f /tmp/collections/requirements.yml

# add ansible role dependencies
COPY ./src/roles/requirements.yml /tmp/roles/requirements.yml

# install ansible role dependencies
RUN ansible-galaxy role install -r /tmp/roles/requirements.yml \
    && rm -f /tmp/roles/requirements.yml

# become a non-root user
USER ${USERNAME}
