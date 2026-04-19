# Azure Weather Dashboard

A weather dashboard built with Flask, deployed on Azure Container Apps with a full CI/CD pipeline via GitHub Actions and Terraform.

## Live App
https://weather-dashboard.orangetree-047de8b2.germanywestcentral.azurecontainerapps.io

## Tech Stack
- **Backend:** Python / Flask
- **External API:** OpenWeatherMap API
- **Container Registry:** Azure Container Registry
- **Hosting:** Azure Container Apps
- **Infrastructure as Code:** Terraform
- **CI/CD:** GitHub Actions — auto-deploy on every git push

## CI/CD Pipeline
Every push to `main` branch automatically:
1. Builds a new Docker image
2. Pushes it to Azure Container Registry
3. Deploys to Azure Container Apps

## Infrastructure
All Azure resources provisioned with Terraform:
- Resource Group
- Azure Container Registry (Basic SKU)
- Container App Environment
- Container App (0.25 vCPU, 0.5GB RAM)

## Local Development
```bash
docker build -t weather-app .
docker run -p 8080:8080 -e OPENWEATHER_API_KEY=your_key weather-app
```