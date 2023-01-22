# terraform

## Setup

1. Prerequisites
  1. GNU make
  1. docker compose
1. Configuration
  1. Add all the OCI, AWS, and custom user configuration inside the `./home` directory, which is mounted as a home directory of the non root user inside the container. The content of `./home` directory is ignored by GIT. Avoid region definition in your OCI configuration.
  1. Add an empty file `.bash_history` to the `./home` directory if you want to have persistent history for Terraform only.
  1. More configuration customization are defined in [Customization](#customization) section

### Customization

Optionally customize via `./docker-compose.override.yml` (file is ignored by GIT), e.g.:

https://docs.docker.com/compose/compose-file/

```yaml
services:
  terraform:
    volumes:
      - ~/.aws:/home/terraform/.aws
      - ~/.oci:/home/terraform/.oci
```

### OCI configuration

Configure OCI access:

- Generate API Signing Key for each tenancy
  - API Signing Key parts are `key_private.pem`, `key_public.pem`, `key_public.pem` fingerprint
  - (concept) https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm
  - (generate manually) https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm
  - (generate via oci cli) https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.18.1/oci_cli_docs/cmdref/setup/config.html
- `$HOME/.oci/config` file content:

  ```ini
  [tenancy1]
  tenancy=
  user=
  fingerprint=
  key_file=

  [tenancyN]
  tenancy=
  user=
  fingerprint=
  key_file=
  ```

Configure OCI object storage access:

- Add OCI object storage S3 credentials for Terraform state backend into `~/.aws/credentials`
- You **must** generate the credentials for each tenancy separately
  - https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm#s3
- `$HOME/.aws/credentials` file content:

  ```ini
  [tenancy1]
  aws_access_key_id=
  aws_secret_access_key=

  [tenancy2]
  aws_access_key_id=
  aws_secret_access_key=
  ```

- Verify configuration

  ```sh
  export compartment_1="ocid1.compartment.oc1..aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  oci --profile tenancy1 --region region_name iam compartment list --compartment-id=${compartment_1}

  export compartment_2="ocid1.compartment.oc1..aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  oci --profile tenancy2 --region region_name iam compartment list --compartment-id=${compartment_2}
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

Run Terraform, always via Terragrunt:

```sh
cd src/tenancy/compartment/logical_unit_1
terragrunt init
terragrunt plan
```
