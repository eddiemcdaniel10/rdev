provider "google" {
  credentials = "${file("~/.gcp/personal-account.json")}"
  project     = "testproj-174015"
  region      = "us-central1"
  zone        = "us-central1-c"
}
resource "google_compute_instance" "rdev-sync-box" {
  name         = "rdev"
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
    gcsfuse rdev-sync-box-io /src
  EOF

}