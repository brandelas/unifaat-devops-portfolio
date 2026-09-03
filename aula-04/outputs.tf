output "vpc_id" {
  description = "ID da VPC TechNova"
  value       = aws_vpc.technova.id
}

output "public_subnet_ids" {
  description = "IDs das subnets publicas"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "api_security_group_id" {
  description = "ID do Security Group da API"
  value       = aws_security_group.api.id
}

output "db_security_group_id" {
  description = "ID do Security Group do banco"
  value       = aws_security_group.db.id
}

output "ec2_public_ip" {
  description = "IP publico da EC2 da API"
  value       = aws_instance.api.public_ip
}

output "api_url" {
  description = "URL da API TechNova"
  value       = format("http://%s:3000", aws_instance.api.public_ip)
}

output "ssh_command" {
  description = "Comando SSH para a EC2 usando o caminho externo da chave privada"
  value       = format("ssh -i <CAMINHO_DA_CHAVE_PRIVADA> ec2-user@%s", aws_instance.api.public_ip)
}
