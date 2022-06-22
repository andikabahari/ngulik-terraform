terraform {
  experiments = [module_variable_optional_attrs]
}

provider "google" {
  project     = "centering-crow-351309"
  region      = "asia-southeast2"
  credentials = "./credentials.json"
}

variable "network_name" {
  description = "Network name"
}

variable "subnet" {
  description = "List of subnet"
  type = list(object({
    name            = string
    range           = string
    secondary_name  = optional(string)
    secondary_range = optional(string)
  }))
}

resource "google_compute_network" "my_net" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnet_01" {
  name          = var.subnet[0].name
  ip_cidr_range = var.subnet[0].range
  network       = google_compute_network.my_net.id
  secondary_ip_range {
    range_name    = var.subnet[0].secondary_name
    ip_cidr_range = var.subnet[0].secondary_range
  }
}

data "google_compute_network" "default_network" {
  name = "default"
}

resource "google_compute_subnetwork" "my_subnet_02" {
  name          = var.subnet[1].name
  ip_cidr_range = var.subnet[1].range
  network       = data.google_compute_network.default_network.id
}

output "my_net_id" {
  value = google_compute_network.my_net.id
}

output "my_subnet_01_gateway" {
  value = google_compute_subnetwork.my_subnet_01.gateway_address
}

output "my_subnet_02_gateway" {
  value = google_compute_subnetwork.my_subnet_02.gateway_address
}
