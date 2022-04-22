packer {
  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }

  required_version = "~> 1.8.0"
}

source "docker" "ubuntu" {
  image  = "ubuntu:22.04"
  commit = true
}

source "docker" "centos" {
  image = "centos:7"
  # commit = true
  # The path where the final container will be exported as a tar file.
  export_path = "./out/centos.tar"
}

build {
  name = "docker-get-started"
  sources = [
    "source.docker.ubuntu"
  ]
}

build {
  name = "docker-get-started"
  sources = [
    "source.docker.centos"
  ]
}
