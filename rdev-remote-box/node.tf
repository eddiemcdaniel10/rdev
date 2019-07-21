variable "creds_file" {
  type = "string"
}

variable "project_id" {
  type = "string"
}

variable "bucket_name" {
  type = "string"
}

provider "google" {
  credentials = "${file("${var.creds_file}")}"
  project     = "${var.project_id}"
  region      = "us-central1"
  zone        = "us-central1-c"
}
resource "google_compute_instance" "rdev-box" {
  name         = "${var.bucket_name}-box"
  machine_type = "n1-standard-2"
  zone         = "us-central1-c"

  scheduling {
      preemptible = true
      automatic_restart = false
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-full"]
  }

  metadata_startup_script = <<EOF
    #!/bin/bash
    export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
    echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    apt-get update
    apt-get install gcsfuse
    mkdir /src
    gcsfuse ${var.bucket_name} /src
  EOF

}