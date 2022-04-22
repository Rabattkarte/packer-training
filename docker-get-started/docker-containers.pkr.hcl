packer {
  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }

  required_version = "~> 1.8.0"
}

variable "ubuntu_image" {
  type    = string
  default = "ubuntu:22.04"
}

variable "centos_image" {
  type    = string
  default = "centos:7"
}

source "docker" "ubuntu" {
  image  = var.ubuntu_image
  commit = true
}

source "docker" "centos" {
  image = var.centos_image
  # commit = true
  # The path where the final container will be exported as a tar file.
  export_path = "./out/centos.tar"
}

build {
  name = "docker-get-started"
  sources = [
    "source.docker.ubuntu"
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
    inline = ["echo Running '${var.ubuntu_image}' Docker image."]
  }
}

build {
  name = "docker-get-started"
  sources = [
    "source.docker.centos"
  ]
}
