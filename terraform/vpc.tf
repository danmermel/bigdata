resource "ibm_is_vpc" "bigDataVpc" {
  name = "big-data-vpc"
}

resource "ibm_is_vpc_routing_table" "bigDataRoutingTable" {
  name   = "big-data-routing-table"
  vpc    = ibm_is_vpc.bigDataVpc.id
}


resource "ibm_is_subnet" "bigDataSubnet1" {
  name            = "big-data-subnet1"
  vpc             = ibm_is_vpc.bigDataVpc.id
  zone            = "eu-gb-1"
  ipv4_cidr_block = "10.242.0.0/18"
  routing_table   = ibm_is_vpc_routing_table.bigDataRoutingTable.routing_table 
  public_gateway = ibm_is_public_gateway.bigDataGateway1.id
}

resource "ibm_is_public_gateway" "bigDataGateway1" {
  name = "big-data-gateway-1"
  vpc  = ibm_is_vpc.bigDataVpc.id
  zone = "eu-gb-1"
}

resource "ibm_is_security_group_rule" "sshRule" {
  group     = ibm_is_vpc.bigDataVpc.default_security_group
  direction = "inbound"
  //remote    = "127.0.0.1"
  tcp {
    port_min = 22
    port_max = 22
  }
}
