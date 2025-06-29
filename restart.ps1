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

# Stop aequify containers
Print-Step "Stopping aequify containers"
$aequifyContainers = docker ps -q --filter "name=aequify"
if ($aequifyContainers) {
    docker stop $aequifyContainers
}

# Remove aequify containers
Print-Step "Removing aequify containers"
$aequifyContainers = docker ps -aq --filter "name=aequify"
if ($aequifyContainers) {
    docker rm $aequifyContainers
}

# Remove aequify images
Print-Step "Removing aequify images"
$aequifyImages = docker images -q --filter "reference=eins0fx/aequify*"
if ($aequifyImages) {
    docker rmi -f $aequifyImages
}

# Remove aequify volumes (if any)
Print-Step "Removing aequify volumes"
$aequifyVolumes = docker volume ls -q --filter "name=aequify"
if ($aequifyVolumes) {
    $aequifyVolumes | ForEach-Object { docker volume rm $_ }
}

# Start compose services in detached mode
Print-Step "Starting Docker Compose services"
docker compose up -d

# Show logs
Print-Step "Showing Docker Compose logs"
Write-Host "`nPress Ctrl+C to stop viewing logs`n" -ForegroundColor Yellow
docker compose logs -f aequify