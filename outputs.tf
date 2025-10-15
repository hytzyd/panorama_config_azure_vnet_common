# ------------------------------------------------------------------
# Management Profile Output
# ------------------------------------------------------------------

output "interface_management_profile_name" {
  description = "The name of the created interface management profile."
  value       = panos_interface_management_profile.az_hp_profile_tf.name
}

# ------------------------------------------------------------------
# Ethernet Interface Outputs
# ------------------------------------------------------------------

output "ethernet_interface_1_name" {
  description = "The name of the first ethernet interface."
  value       = panos_ethernet_interface.iface1.name
}

output "ethernet_interface_2_name" {
  description = "The name of the second ethernet interface."
  value       = panos_ethernet_interface.iface2.name
}

# ------------------------------------------------------------------
# Zone Outputs
# ------------------------------------------------------------------

output "public_zone_name" {
  description = "The name of the public zone."
  value       = panos_zone.zone_public.name
}

output "private_zone_name" {
  description = "The name of the private zone."
  value       = panos_zone.zone_private.name
}

# ------------------------------------------------------------------
# Address Object Outputs
# ------------------------------------------------------------------

output "address_object_azure_health_probe" {
  description = "The name of the Azure Health Probe address object."
  value       = panos_address.az_hp_tf.name
}

output "address_object_fws_public_subnet" {
  description = "The name of the firewalls' public subnet address object."
  value       = panos_address.FWs_public_subnet.name
}

output "address_object_fws_private_subnet" {
  description = "The name of the firewalls' private subnet address object."
  value       = panos_address.FWs_private_subnet.name
}

output "address_object_appgw_subnet" {
  description = "The name of the Application Gateway subnet address object."
  value       = panos_address.AppGW_subnet.name
}

output "address_object_spokes_subnet" {
  description = "The name of the spokes subnet address object."
  value       = panos_address.Spokes_subnet.name
}

output "address_object_public_lb_ip" {
  description = "The name of the public load balancer IP address object."
  value       = panos_address.public_lb_ip_tf.name
}

output "address_object_app1_private_ip" {
  description = "The name of the App1 private IP address object."
  value       = panos_address.app1_private_ip.name
}

output "address_object_app2_private_ip" {
  description = "The name of the App2 private IP address object."
  value       = panos_address.app2_private_ip.name
}

# ------------------------------------------------------------------
# Routing Output
# ------------------------------------------------------------------

output "logical_router_name" {
  description = "The name of the logical router."
  value       = panos_logical_router.LR2_tf.name
}

# ------------------------------------------------------------------
# Security Policy Output
# ------------------------------------------------------------------

output "security_policy_rule_names" {
  description = "A list of names for the created security policy rules."
  value       = [for rule in panos_security_policy.sec_postrules.rules : rule.name]
}

# ------------------------------------------------------------------
# NAT Policy Output
# ------------------------------------------------------------------

output "nat_policy_rule_names" {
  description = "A list of names for the created NAT policy rules."
  value       = [for rule in panos_nat_policy.nat_postrules.rules : rule.name]
}