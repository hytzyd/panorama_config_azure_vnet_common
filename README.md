Fast-Track Your Azure Panorama Lab Setup!
This repository contains Terraform configuration for a Palo Alto Networks Panorama setup in an Azure Transit VNet. Mainly built to configure Panorama after this:
https://github.com/PaloAltoNetworks/terraform-azurerm-swfw-modules/tree/main/examples/vmseries_transit_vnet_common

## What's the Point?
To save you from the tedious task of manual configuration! The goal is to get a fully functional lab environment up and running in a fraction of the time.

## How It Works
Deploy your firewall VM in Azure using this repo:
https://github.com/PaloAltoNetworks/terraform-azurerm-swfw-modules/tree/main/examples/vmseries_transit_vnet_common

Clone this repository and set your parameters in the tfvars file

Run the Terraform code.

That's it! The plan will automatically configure your Panorama template and device group with all the necessary settings, including:

Network Interfaces

Logical Routers & Routing Tables - This is built for the advanced routing engine in VMs

Address Objects

Security & NAT Policies

