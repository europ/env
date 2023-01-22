terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  config_file_profile = "" # defined in OCI config file
  region              = "" # avoid region definition in OCI config file
}
