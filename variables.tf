variable "panorama_hostname" {
  description = "The hostname or IP address of the Panorama instance."
  type        = string
}

variable "panorama_username" {
  description = "The username for Panorama."
  type        = string
}

variable "panorama_password" {
  description = "The password for Panorama."
  type        = string
  sensitive   = true
}

variable "skip_cert" {
  description = "If set to true, the provider will not validate the Panorama TLS certificate."
  type        = bool
  default     = false # Defaulting to the more secure option
}

variable "template" {
  description = "Panorama Template"
  type        = string
}

variable "device_group" {
  description = "Panorama Device Group"
  type        = string
}

variable "public_snet" {
  description = "FWs Public Subnet"
  type = string
}

variable "private_snet" {
  description = "FWs Private Subnet"
  type = string
}

variable "appgw_snet" {
  description = "Application GW Subnet"
  type = string
}

variable "spokes_snet" {
  description = "Spokes Subnet"
  type = string
}

variable "public_lb_ip" {
  description = "Public LB Frontend IP"
  type = string
}

variable "app1_private_ip" {
  description = "App1 VM private IP Address"
  type = string
}

variable "app2_private_ip" {
  description = "App2 VM private IP Address"
  type = string
}