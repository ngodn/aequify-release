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

# Stop aequify containers
print_step "Stopping aequify containers"
docker ps -q --filter "name=aequify" | xargs -r docker stop

# Remove aequify containers
print_step "Removing aequify containers"
docker ps -aq --filter "name=aequify" | xargs -r docker rm

# Remove aequify images
print_step "Removing aequify images"
docker images -q --filter "reference=eins0fx/aequify*" | xargs -r docker rmi -f

# Remove aequify volumes (if any)
print_step "Removing aequify volumes"
docker volume ls -q --filter "name=aequify" | xargs -r docker volume rm

echo "Aequify Docker cleanup completed successfully!"