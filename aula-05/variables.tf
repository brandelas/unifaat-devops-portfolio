variable "region" {
  description = "Regiao AWS para os recursos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "TechNova"
}

variable "environment" {
  description = "Ambiente da infraestrutura"
  type        = string
  default     = "development"
}

variable "owner" {
  description = "RA do responsavel pelos recursos"
  type        = string
  default     = "2325096"
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones utilizadas"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets publicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs das subnets privadas"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "db_name" {
  description = "Nome do banco PostgreSQL"
  type        = string
  default     = "technova"
}

variable "db_username" {
  description = "Usuario administrador do PostgreSQL"
  type        = string
  default     = "technova_admin"
}

variable "db_password" {
  description = "Senha do PostgreSQL"
  type        = string
  sensitive   = true
}
variable "use_academy_instance_profile" {
  description = "Usa o LabInstanceProfile existente do AWS Academy. Mantenha true no Learner Lab."
  type        = bool
  default     = true
}

variable "academy_instance_profile_name" {
  description = "Nome do Instance Profile pre-existente no AWS Academy"
  type        = string
  default     = "LabInstanceProfile"
}

variable "key_pair_name" {
  description = "Nome do Key Pair existente na AWS"
  type        = string
  default     = "technova-aula04"
}
