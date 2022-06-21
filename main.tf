provider "google" {
  project = "centering-crow-351309"
  region  = "asia-southeast2"
}

variable "network_name" {
  description = "Network name"
}

variable "subnet_01_name" {
  description = "Name for subnet 01"
}

variable "subnet_01_ip_cidr_range" {
  description = "CIDR range for subnet 01"
}

variable "subnet_01_secondary_name" {
  description = "Name for secondary subnet 01"
}

variable "subnet_01_secondary_ip_cidr_range" {
  description = "Secondary CIDR range for subnet 01"
}

variable "subnet_02_name" {
  description = "Name for subnet 02"
}

variable "subnet_02_ip_cidr_range" {
  description = "CIDR range for subnet 02"
}

resource "google_compute_network" "dev_net" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev_subnet_01" {
  name          = var.subnet_01_name
  ip_cidr_range = var.subnet_01_ip_cidr_range
  network       = google_compute_network.dev_net.id
  secondary_ip_range {
    range_name    = var.subnet_01_secondary_name
    ip_cidr_range = var.subnet_01_secondary_ip_cidr_range
  }
}

data "google_compute_network" "default_network" {
  name = "default"
}

resource "google_compute_subnetwork" "dev_subnet_02" {
  name          = var.subnet_02_name
  ip_cidr_range = var.subnet_02_ip_cidr_range
  network       = data.google_compute_network.default_network.id
}

output "dev_net_id" {
  value = google_compute_network.dev_net.id
}

output "dev_subnet_01_gateway" {
  value = google_compute_subnetwork.dev_subnet_01.gateway_address
}

output "dev_subnet_02_gateway" {
  value = google_compute_subnetwork.dev_subnet_02.gateway_address
}
