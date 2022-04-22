# Info

This dir is based on [this **docker-get-started** tutorial by HashiCorp](https://learn.hashicorp.com/collections/packer/docker-get-started).

## `history` dumping ground

```sh
# Init this Packer project
packer init docker-containers.pkr.hcl

# Format Packer HCL2
packer fmt docker-containers.pkr.hcl

# Build containers
packer build docker-containers.pkr.hcl

# Build containers, overriding variables
packer build --var-file=example_config.pkrvars.hcl docker-containers.pkr.hcl

# Build all except ubuntu container
packer build -except='*.ubuntu' docker-containers.pkr.hcl

# List all local Docker images
docker images | sort

# Remove dangling Docker images
docker image prune

# Remove all unused Docker images
docker image prune --all
```
