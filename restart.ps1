# Function to print step information
function Print-Step {
    param (
        [string]$StepName
    )
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host "Step: $StepName" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
}

# Stop all containers and remove compose services
Print-Step "Stopping Docker Compose services"
docker compose down

# Stop all running containers except PostgreSQL and pgAdmin
Print-Step "Stopping all running containers (except PostgreSQL and pgAdmin)"
$runningContainers = docker ps -q --filter "name=^(?!.*(postgres|pgadmin)).*"
if ($runningContainers) {
    docker stop $runningContainers
}

# Remove all containers except PostgreSQL and pgAdmin
Print-Step "Removing all containers (except PostgreSQL and pgAdmin)"
$allContainers = docker ps -aq --filter "name=^(?!.*(postgres|pgadmin)).*"
if ($allContainers) {
    docker rm $allContainers
}

# Remove all images except PostgreSQL and pgAdmin images
Print-Step "Removing all Docker images (except PostgreSQL and pgAdmin)"
$allImages = docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | Where-Object { $_ -notmatch "postgres|pgadmin" } | ForEach-Object { ($_ -split ' ')[1] }
if ($allImages) {
    docker rmi -f $allImages
}

# Remove all volumes except PostgreSQL and pgAdmin volumes
Print-Step "Removing all Docker volumes (except PostgreSQL and pgAdmin)"
$volumes = docker volume ls -q | Where-Object { $_ -notmatch "postgres|pgadmin" }
if ($volumes) {
    $volumes | ForEach-Object { docker volume rm $_ }
}

# Start compose services in detached mode
Print-Step "Starting Docker Compose services"
docker compose up -d

# Show logs
Print-Step "Showing Docker Compose logs"
Write-Host "`nPress Ctrl+C to stop viewing logs`n" -ForegroundColor Yellow
docker compose logs -f