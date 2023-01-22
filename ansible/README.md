# ansible

## Setup

1. Prerequisites
  1. GNU make
  1. docker compose
1. Configuration
  1. Add all custom user configuration inside the `./home` directory, which is mounted as a home directory of the non root user inside the container. The content of `./home` directory is ignored by GIT. 
  1. Add an empty file `.bash_history` to the `./home` directory if you want to have persistent history for Ansible only.
  1. More configuration customization are defined in [Customization](#customization) section

### Customization

Optionally customize via `./docker-compose.override.yml` (file is ignored by GIT), e.g.:

https://docs.docker.com/compose/compose-file/

```yaml
services:
  terraform:
    volumes:
      - ~/.oci:/home/ansible/.oci
```

## Usage

Build image:

```sh
make build
```

Start container:

```sh
make run
```

Run Ansible playbook:

```sh
ansible-playbook -i ./src/inventory ./src/playbooks/example_playbook.yml
```
