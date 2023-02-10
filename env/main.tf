
module "vpc" {
  source     = "../../module/vpc"

  project_id = var.project_id
  region     = var.region
}

module "gke" {
  source = "../../module/gke"

  project_id                 = var.project_id
  region                     = var.region
  location                   = var.region
  node_zones                 = var.cluster_node_zones
  service_account            = var.service_account
  network                    = module.vpc.network
  subnet_name                = module.vpc.private_subnet.name
  master_ipv4_cidr_block     = module.vpc.cluster_master_ip_cidr_range
  pods_ipv4_cidr_block       = module.vpc.cluster_pods_ip_cidr_range
  services_ipv4_cidr_block   = module.vpc.cluster_services_ip_cidr_range
  authorized_ipv4_cidr_block = "192.168.1.242/32" #will be used for bastion in future 
  depends_on_subnetwork      = module.vpc.private_subnet.name
}


module "cloud-sql" {
  source         = "../../module/cloud-sql"

  network_name   = module.vpc.network
  sql_region     = "europe-north1"
  zone           = "europe-north1-a"
  db_depends_on  = module.vpc.google_service_networking_connection
}


module "instance" {
  source         = "../../module/instance"

  network        = module.vpc.network
  subnetwork     = module.vpc.public_subnet.name
  ins_depends_on = module.vpc.public_subnet.name
} 