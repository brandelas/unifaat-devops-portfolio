variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "db_username" {
  description = "Usuário administrador do banco de dados"
  type        = string
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "IDs das subnets privadas para o DB Subnet Group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "IDs dos Security Groups associados ao RDS"
  type        = list(string)
}

variable "instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "environment" {
  description = "Ambiente de execução"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}