variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = "weather-dashboard-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "germanywestcentral"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "weather-dashboard"
}

variable "openweather_api_key" {
  description = "OpenWeatherMap API key"
  type        = string
  sensitive   = true
}