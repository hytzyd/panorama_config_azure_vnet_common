# ------------------------------------------------------------------
# Calculate the first IP in public and private snets
# ------------------------------------------------------------------
locals {
  public_snet_gw = cidrhost(var.public_snet, 1)
  private_snet_gw = cidrhost(var.private_snet, 1)
}

# ------------------------------------------------------------------
# interface management profile
# ------------------------------------------------------------------
resource "panos_interface_management_profile" "az_hp_profile_tf" {
  location = {
    template = {
      name = var.template
    }
  }

  name = "az_hp_tf"

  http = true
  https = true
  ssh = true

  permitted_ips = [
    { name = "168.63.129.16/32" },
    { name = var.appgw_snet }
  ]

}
# ------------------------------------------------------------------
# ethernet interfaces
# ------------------------------------------------------------------

resource "panos_ethernet_interface" "iface1" {
  depends_on = [
    panos_interface_management_profile.az_hp_profile_tf
  ]
  
  location = {
    template = {
      name = var.template
    }
  }
  
  name = "ethernet1/1"
  

  layer3 = {
    interface_management_profile = panos_interface_management_profile.az_hp_profile_tf.name
    dhcp_client = {
      enable = true
      create_default_route = false
    }
  }
  
}

resource "panos_ethernet_interface" "iface2" {
  depends_on = [
    panos_interface_management_profile.az_hp_profile_tf
  ]
  
  location = {
    template = {
      name = var.template
    }
  }
  
  name = "ethernet1/2"
  

  layer3 = {
    interface_management_profile = panos_interface_management_profile.az_hp_profile_tf.name
    dhcp_client = {
      enable = true
      create_default_route = false
    }
  }
  
}

# ------------------------------------------------------------------
# Zones
# ------------------------------------------------------------------

resource "panos_zone" "zone_public" {
  depends_on = [
    panos_ethernet_interface.iface1
  ]

  location = {
    template = {
      name = var.template
    }
  }

  name = "public-tf"

  enable_device_identification = true
  enable_user_identification   = true

  network = {
    layer3                          = [panos_ethernet_interface.iface1.name]
    enable_packet_buffer_protection = true
  }
}

resource "panos_zone" "zone_private" {
  depends_on = [
    panos_ethernet_interface.iface2
  ]

  location = {
    template = {
      name = var.template
    }
  }

  name = "private-tf"

  enable_device_identification = true
  enable_user_identification   = true

  network = {
    layer3                          = [panos_ethernet_interface.iface2.name]
    enable_packet_buffer_protection = true
  }
}

# ------------------------------------------------------------------
# Address Objects
# ------------------------------------------------------------------

resource "panos_address" "az_hp_tf" {
    location = {
    device_group = {
      name = var.device_group
    }
  }
  name         = "az_hp_tf"
  ip_netmask   = "168.63.129.16/32"
  description  = "Azure LBs Health Probe - TF Created"
}

resource "panos_address" "FWs_public_subnet" {
    location = {
    device_group = {
      name = var.device_group
    }
  }
  name         = "FWs_Public_TF"
  ip_netmask   = var.public_snet
  description  = "FWs Public Subnet - TF Created"
}

resource "panos_address" "FWs_private_subnet" {
    location = {
    device_group = {
      name = var.device_group
    }
  }
  name         = "FWs_Private_TF"
  ip_netmask   = var.private_snet
  description  = "FWs Private Subnet - TF Created"
}

resource "panos_address" "AppGW_subnet" {
    location = {
    device_group = {
      name = var.device_group
    }
  }
  name         = "AppGW_snet_TF"
  ip_netmask   = var.appgw_snet
  description  = "Application Gateway Subnet - TF Created"
}

resource "panos_address" "Spokes_subnet" {
    location = {
    device_group = {
      name = var.device_group
    }
  }
  name         = "Spokes_snet_TF"
  ip_netmask   = var.spokes_snet
  description  = "Sokes Subnet - TF Created"
}

resource "panos_address" "public_lb_ip_tf" {
    location = {
    device_group = {
      name = var.device_group
    }
  }
  name         = "public_lb_ip_tf"
  ip_netmask   = var.public_lb_ip
  description  = "Public Load Balancer Frontend IP"
}

resource "panos_address" "app1_private_ip" {
    location = {
    device_group = {
      name = var.device_group
    }
  }
  name         = "app1_private_ip_tf"
  ip_netmask   = var.app1_private_ip
  description  = "App1 VM private IP Address"
}

resource "panos_address" "app2_private_ip" {
    location = {
    device_group = {
      name = var.device_group
    }
  }
  name         = "app2_private_ip_tf"
  ip_netmask   = var.app2_private_ip
  description  = "App2 VM private IP Address"
}

# ------------------------------------------------------------------
# Routing
# ------------------------------------------------------------------

resource "panos_logical_router" "LR2_tf" {

  depends_on = [
    panos_ethernet_interface.iface1, panos_ethernet_interface.iface2
  ]

  location = {
    template = {
      name = var.template
    }
  }

  name = "LR2-tf"

  vrf = [ {
    name = "default"
    ecmp = {
      enable = true
      symmetric_return = true
    }
    interface = [ panos_ethernet_interface.iface1.name,panos_ethernet_interface.iface2.name ]
    routing_table = {
      ip = {
        static_route = [
        {
          name = "Default-Internet"
          destination = "0.0.0.0/0"
          interface = panos_ethernet_interface.iface1.name
          nexthop = {ip_address = local.public_snet_gw}
        },
        {
          name = "az_hp_public"
          destination = "168.63.129.16/32"
          interface = panos_ethernet_interface.iface1.name
          nexthop = {ip_address = local.public_snet_gw}
        },
        {
          name = "az_hp_private"
          destination = "168.63.129.16/32"
          interface = panos_ethernet_interface.iface2.name
          nexthop = {ip_address = local.private_snet_gw}
        },
        {
          name = "appgw"
          destination = var.appgw_snet
          interface = panos_ethernet_interface.iface1.name
          nexthop = {ip_address = local.public_snet_gw}
        },        
        {
          name = "spokes"
          destination = var.spokes_snet
          interface = panos_ethernet_interface.iface2.name
          nexthop = {ip_address = local.private_snet_gw}
        }
        ]
      }
    }
  } ]
}

# ------------------------------------------------------------------
# Security Policies
# ------------------------------------------------------------------

resource "panos_security_policy" "sec_postrules" {
    location = {
    device_group = {
      name = var.device_group
      rulebase = "post-rulebase"
    }
  }

  rules = [
    {
      name                  = "az_hp_tf",
      source_zones          = [panos_zone.zone_public.name,panos_zone.zone_private.name],
      source_addresses      = [panos_address.az_hp_tf.name],
      destination_zones     = [panos_zone.zone_public.name,panos_zone.zone_private.name],
      destination_addresses = ["any"],
      services              = ["any"],
      applications          = ["any"],
      log_end               = false
    },
    {
      name                  = "app1_tf",
      source_zones          = [panos_zone.zone_public.name],
      source_addresses      = ["any"],
      destination_zones     = [panos_zone.zone_private.name],
      destination_addresses = [panos_address.public_lb_ip_tf.name],
      applications          = ["any"],
      services              = ["application-default"],
    },
    {
      name                  = "app2_tf",
      source_zones          = [panos_zone.zone_public.name],
      source_addresses      = ["any"],
      destination_zones     = [panos_zone.zone_private.name],
      destination_addresses = [panos_address.FWs_public_subnet.name],
      applications          = ["any"],
      services              = ["application-default"],

      action = "allow",
      rule_type = "universal"
    },
    {
      name                  = "spokes_inet_tf",
      source_zones          = [panos_zone.zone_private.name],
      source_addresses      = [panos_address.Spokes_subnet.name],
      destination_zones     = [panos_zone.zone_public.name],
      destination_addresses = ["any"],
      applications          = ["any"],
      services              = ["application-default"],

      action = "allow",
      rule_type = "universal"
    }
  ]
}

# ------------------------------------------------------------------
# NAT policies
# ------------------------------------------------------------------

resource "panos_nat_policy" "nat_postrules" {
    location = {
    device_group = {
      name = var.device_group
      rulebase = "post-rulebase"
    }
  }

  rules = [
    {
      name = "spokes_inet_tf"

      source_zones          = [panos_zone.zone_private.name]
      source_addresses      = [panos_address.Spokes_subnet.name]
      destination_zone      = [panos_zone.zone_public.name]
      destination_addresses = ["any"]
      services              = ["any"]

      source_translation = {
        dynamic_ip_and_port ={
          interface_address = {
            interface = panos_ethernet_interface.iface1.name
          }
        }
      }
    },
    {
      name = "app1_tf"

      source_zones          = [panos_zone.zone_public.name]
      source_addresses      = ["any"]
      destination_zone      = [panos_zone.zone_public.name]
      destination_addresses = [panos_address.public_lb_ip_tf.name]
      services              = ["any"]

      source_translation = {
        dynamic_ip_and_port ={
          interface_address = {
            interface = panos_ethernet_interface.iface2.name
          }
        }
      }

      destination_translation = {
       translated_address = panos_address.app1_private_ip.name
      }
    },
    {
      name = "app2_tf"

      source_zones          = [panos_zone.zone_public.name]
      source_addresses      = [panos_address.AppGW_subnet.name]
      destination_zone      = [panos_zone.zone_public.name]
      destination_addresses = ["any"]
      services              = ["any"]

      source_translation = {
        dynamic_ip_and_port ={
          interface_address = {
            interface = panos_ethernet_interface.iface2.name
          }
        }
      }

      dynamic_destination_translation = {
       translated_address = panos_address.app2_private_ip.name
      }
    }
  ]
}
