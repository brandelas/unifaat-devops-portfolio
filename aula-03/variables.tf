variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "TechNova"
}

variable "environment" {
  description = "Ambiente da infraestrutura"
  type        = string
  default     = "dev"
}

variable "aluno" {
  description = "Nome do aluno"
  type        = string
  default     = "Eloísa Brandão"
}

variable "ra" {
  description = "RA do aluno"
  type        = string
  default     = "2325096"
}

variable "disciplina" {
  description = "Disciplina"
  type        = string
  default     = "DevOps - UniFAAT 2026-2"
}

variable "aula" {
  description = "Número da aula"
  type        = string
  default     = "03"
}