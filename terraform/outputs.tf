output "app_url" {
  description = "Weather Dashboard URL"
  value       = "https://${azurerm_container_app.main.ingress[0].fqdn}"
}

output "container_registry_url" {
  description = "Container Registry login server"
  value       = azurerm_container_registry.main.login_server
}