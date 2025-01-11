#!/bin/bash

# Function to print step information
print_step() {
    echo "===================================="
    echo "Step: $1"
    echo "===================================="
}

# Stop all containers and remove compose services
print_step "Stopping Docker Compose services"
docker compose down

# Stop all running containers
print_step "Stopping all running containers"
docker stop $(docker ps -aq)

# Remove all containers
print_step "Removing all containers"
docker rm $(docker ps -aq)

# Remove all images forcefully
print_step "Removing all Docker images"
docker rmi -f $(docker images -aq)

# Remove all volumes
print_step "Removing all Docker volumes"
docker volume ls -q | xargs -r docker volume rm
