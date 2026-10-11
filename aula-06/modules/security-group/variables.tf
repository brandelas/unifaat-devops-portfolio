variable "name" {
  description = "Nome do Security Group"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}

variable "rules" {
  description = "Regras de entrada do Security Group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "environment" {
  description = "Ambiente de execução"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}