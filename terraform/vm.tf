resource "ibm_is_ssh_key" "bigDataKey" {
  name       = "big-data-ssh"
  public_key = var.public_key
} 

resource "ibm_is_instance" "bigDataVM" {
  name    = "big-data-vm"
  image   = "r018-4c95937f-f1cd-4582-bc3d-bf3437512412"  //debian 10
  profile = "bx2d-2x8"

  primary_network_interface {
    subnet = ibm_is_subnet.bigDataSubnet1.id
    primary_ipv4_address = "10.242.0.6"
    //allow_ip_spoofing = true
  }

  vpc  = ibm_is_vpc.bigDataVpc.id
  zone = ibm_is_subnet.bigDataSubnet1.zone
  keys = [ibm_is_ssh_key.bigDataKey.id]

}

resource "ibm_is_floating_ip" "bigDataFIP" {
  name   = "big-data-fip"
  target = ibm_is_instance.bigDataVM.primary_network_interface[0].id
}

output "vm_ip_address" {
  value = ibm_is_floating_ip.bigDataFIP.address 
  
}