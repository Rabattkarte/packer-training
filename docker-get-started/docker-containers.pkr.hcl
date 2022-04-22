#####
# Settings
#####

packer {
  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }

  required_version = "~> 1.8.0"
}

#####
# Variables
#####

variable "ubuntu_image_tag" {
  type    = string
  default = "22.04"
}

variable "centos_image_tag" {
  type    = string
  default = "7"
}

#####
# Sources
#####

source "docker" "ubuntu" {
  image  = "ubuntu:${var.ubuntu_image_tag}"
  commit = true
}

source "docker" "centos" {
  image = "centos:${var.centos_image_tag}"
  commit = true
  # The path where the final container will be exported as a tar file.
  # export_path = "./out/centos.tar"
}

#####
# Builds
#####

build {
  name = "docker-get-started"
  sources = [
    "source.docker.ubuntu",
    "source.docker.centos"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Printing all default env vars",
      "echo \"PACKER_BUILD_NAME is $PACKER_BUILD_NAME\" >> example.txt",
      "echo \"PACKER_BUILDER_TYPE is $PACKER_BUILDER_TYPE\" >> example.txt",
      "echo \"PACKER_HTTP_ADDR is $PACKER_HTTP_ADDR\" >> example.txt"
    ]
  }

  provisioner "shell" {
    only   = ["docker.ubuntu"]
    inline = ["echo Running 'ubuntu:${var.ubuntu_image_tag}' Docker image."]
  }

  provisioner "shell" {
    only   = ["docker.centos"]
    inline = ["echo Running 'docker:${var.centos_image_tag}' Docker image."]
  }

  post-processor "docker-tag" {
    repository = "packer-docker-get-started-ubuntu"
    tags       = [var.ubuntu_image_tag, "packer-rocks"]
    only       = ["docker.ubuntu"]
  }

  post-processor "docker-tag" {
    repository = "packer-docker-get-started-centos"
    tags       = [var.centos_image_tag, "packer-rocks"]
    only       = ["docker.centos"]
  }
}
