terraform {
  # https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm#s3
  backend "s3" {
    profile                     = ""
    endpoint                    = ""
    region                      = ""
    bucket                      = "terraform-state-file"
    key                         = "logical_unit_1.tfstate"
    encrypt                     = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
