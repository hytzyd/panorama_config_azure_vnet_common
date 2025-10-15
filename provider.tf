terraform {
  required_providers {
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "~> 2.0.5"
    }
  }
}

provider "panos" {
  hostname = var.panorama_hostname
  username = var.panorama_username
  password = var.panorama_password
  skip_verify_certificate =  var.skip_cert
}