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

# Stop all running containers except PostgreSQL and pgAdmin
print_step "Stopping all running containers (except PostgreSQL and pgAdmin)"
docker ps --format "table {{.Names}}" | grep -v -E "(postgres|pgadmin)" | grep -v NAMES | xargs -r docker stop

# Remove all containers except PostgreSQL and pgAdmin
print_step "Removing all containers (except PostgreSQL and pgAdmin)"
docker ps -a --format "table {{.Names}}" | grep -v -E "(postgres|pgadmin)" | grep -v NAMES | xargs -r docker rm

# Remove all images except PostgreSQL and pgAdmin images
print_step "Removing all Docker images (except PostgreSQL and pgAdmin)"
docker images --format "table {{.Repository}}:{{.Tag}}" | grep -v -E "(postgres|pgadmin)" | grep -v REPOSITORY | xargs -r docker rmi -f

# Remove all volumes except PostgreSQL and pgAdmin volumes
print_step "Removing all Docker volumes (except PostgreSQL and pgAdmin)"
docker volume ls -q | grep -v -E "(postgres|pgadmin)" | xargs -r docker volume rm

# Start compose services in detached mode
print_step "Starting Docker Compose services"
docker compose up -d

# Show logs
print_step "Showing Docker Compose logs"
docker compose logs -f aeqcore