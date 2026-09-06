variable "region" {
  description = "Regiao AWS para os recursos"
  type        = string
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
  description = "Duas Availability Zones para as subnets"
  type        = list(string)
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

variable "key_pair_name" {
  description = "Nome do Key Pair registrado na AWS"
  type        = string
}

variable "public_key_path" {
  description = "Caminho local da chave publica SSH"
  type        = string
}

variable "technova_api_repo_url" {
  description = "URL real do repositorio publico technova-api"
  type        = string
  nullable    = false
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

variable "create_dedicated_iam_role" {
  description = "Cria role e Instance Profile com AmazonS3ReadOnlyAccess; use apenas fora do AWS Academy."
  type        = bool
  default     = false

  validation {
    condition     = var.use_academy_instance_profile || var.create_dedicated_iam_role
    error_message = "Use o profile do Academy ou habilite a criacao da role dedicada."
  }
}
