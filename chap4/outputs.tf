output "db-password" {
  description = "Password for the database"
  value       = module.database.db-config.password
  sensitive = true
}

output "lb-dns-name" {
  description = "Domain name of the load balancer"
  value       = module.autoscaling.lb-dns-name
}