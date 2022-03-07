resource "ibm_database" "redisdb" {
  resource_group_id = ibm_resource_group.resource_group.id
  name                                 = "redis-big-data"
  service                              = "databases-for-redis"
  plan                                 = "standard"
  location                             = "eu-gb"
  tags                                 = []
  adminpassword = var.redis_password
  members_memory_allocation_mb = 122880
}

output "redis_crn" {
  value = ibm_database.redisdb.id 
}

output "redis_host" {
  value = ibm_database.redisdb.connectionstrings[0].hosts[0].hostname
}

output "redis_port" {
  value = ibm_database.redisdb.connectionstrings[0].hosts[0].port
}