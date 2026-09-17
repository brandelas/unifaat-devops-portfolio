output "vpc_id" {
  description = "ID da VPC do ambiente dev"
  value       = module.vpc.vpc_id
}

output "api_instance_id" {
  description = "ID da instância EC2 da API"
  value       = module.api_server.instance_id
}

output "api_public_ip" {
  description = "IP público da instância EC2 da API"
  value       = module.api_server.public_ip
}

output "db_endpoint" {
  description = "Endpoint do banco PostgreSQL"
  value       = module.database.db_endpoint
}

output "db_name" {
  description = "Nome do banco PostgreSQL"
  value       = module.database.db_name
}

output "db_port" {
  description = "Porta do banco PostgreSQL"
  value       = module.database.db_port
}