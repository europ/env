locals {
  compartment_id = "" # OCI compartment OCID
}

resource "oci_objectstorage_bucket" "main" {
  compartment_id = local.compartment_id
  namespace      = "" # OCI tenancy name
  name           = "terraform-state-file"
  versioning     = "Enabled"
}
