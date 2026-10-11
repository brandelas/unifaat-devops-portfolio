variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
}

variable "subnets" {
  description = "Mapa de subnets públicas e privadas"
  type = map(object({
    cidr_block = string
    type       = string
    az         = string
  }))
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente de execução"
  type        = string
}