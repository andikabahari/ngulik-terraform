provider "google" {
  project = "centering-crow-351309"
  region  = "asia-southeast2"
}

resource "google_compute_network" "dev_net" {
  name                    = "dev-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev_subnet_01" {
  name          = "dev-subnet-01"
  ip_cidr_range = "10.100.0.0/16"
  network       = google_compute_network.dev_net.id
  secondary_ip_range {
    range_name    = "secondary-range-01"
    ip_cidr_range = "192.168.10.0/24"
  }
}

data "google_compute_network" "default_network" {
  name = "default"
}

resource "google_compute_subnetwork" "dev_subnet_02" {
  name          = "dev-subnet-02"
  ip_cidr_range = "10.110.0.0/16"
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
