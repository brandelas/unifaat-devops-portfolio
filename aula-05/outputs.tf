output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.technova.id
}

output "rds_endpoint" {
  description = "Endpoint completo do RDS"
  value       = module.rds.db_endpoint
}

output "rds_address" {
  description = "Endereco do RDS"
  value       = split(":", module.rds.db_endpoint)[0]
}

output "rds_port" {
  description = "Porta do PostgreSQL"
  value       = module.rds.db_port
}

output "rds_database_name" {
  description = "Nome do banco de dados"
  value       = module.rds.db_name
}

output "ec2_public_ip" {
  description = "IP publico da EC2"
  value       = aws_instance.api.public_ip
}

output "connection_string" {
  description = "String de conexao com o PostgreSQL"
  value       = "postgresql://${var.db_username}:<DB_PASSWORD>@${split(":", module.rds.db_endpoint)[0]}:${module.rds.db_port}/${module.rds.db_name}"
  sensitive   = true
}