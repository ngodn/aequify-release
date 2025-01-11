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

# Stop all running containers
Print-Step "Stopping all running containers"
$runningContainers = docker ps -q
if ($runningContainers) {
    docker stop $runningContainers
}

# Remove all containers
Print-Step "Removing all containers"
$allContainers = docker ps -aq
if ($allContainers) {
    docker rm $allContainers
}

# Remove all images forcefully
Print-Step "Removing all Docker images"
$allImages = docker images -q
if ($allImages) {
    docker rmi -f $allImages
}

# Remove all volumes
Print-Step "Removing all Docker volumes"
$volumes = docker volume ls -q
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