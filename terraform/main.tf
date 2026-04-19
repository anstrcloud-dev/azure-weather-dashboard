terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource group — container for all resources
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Container Registry — stores Docker images
resource "azurerm_container_registry" "main" {
  name                = "weatherdashboardacr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                = "weather-dashboard-env"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

# Container App — runs the weather dashboard
resource "azurerm_container_app" "main" {
  name                         = var.app_name
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode                = "Single"

  registry {
    server               = azurerm_container_registry.main.login_server
    username             = azurerm_container_registry.main.admin_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = azurerm_container_registry.main.admin_password
  }

  secret {
    name  = "openweather-api-key"
    value = var.openweather_api_key
  }

  template {
    container {
      name   = "weather-dashboard"
      image  = "${azurerm_container_registry.main.login_server}/weather-app:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name        = "OPENWEATHER_API_KEY"
        secret_name = "openweather-api-key"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}