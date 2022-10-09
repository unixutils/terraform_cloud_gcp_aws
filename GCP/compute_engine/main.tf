provider "google" {
project  = "kinetic-anvil-245106"
}

resource "google_compute_network" "my_compute_network" {
    project                 = "kinetic-anvil-245106"
    name                    = "my-custom-mode-network"
    auto_create_subnetworks = false
    mtu                     = 1460
}

resource "google_compute_subnetwork" "my_compute_subnet" {
    name          = "my-custom-subnet"
    ip_cidr_range = "10.0.1.0/24"
    region        = "us-west1"
    network = google_compute_network.my_compute_network.id
}

resource "google_compute_instance" "my_compute_engine" {
     name         = "flask-vm"
    machine_type = "f1-micro"
    zone         = "us-west1-a"
    tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"

  network_interface {
    subnetwork = google_compute_subnetwork.my_compute_subnet.id
  }
}