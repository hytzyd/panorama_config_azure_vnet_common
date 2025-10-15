
# ---------------------------------------------------
# Connecting to Panorama
# ---------------------------------------------------
panorama_hostname = "1.1.1.1"
panorama_username = "panadmin"
panorama_password = "********"
skip_cert  = true // skip panorama certificate verfication

template = "vnet-common-tp"         // template name
device_group = "vnet-common-dg"     // device group name

# ---------------------------------------------------
# addresses from VMs deployment
# ---------------------------------------------------
public_snet = "10.0.0.16/28"
private_snet = "10.0.0.32/28"
appgw_snet = "10.0.0.48/28"
spokes_snet = "10.100.0.0/16"

# ---------------------------------------------------
# Modify this with the assigned IP to your Public LB and Apps VMs
# ---------------------------------------------------
public_lb_ip = "1.2.3.4/32"
app1_private_ip = "10.100.0.4/32"
app2_private_ip = "10.100.1.4/32"