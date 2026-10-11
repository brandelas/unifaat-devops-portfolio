# Portfólio DevOps — UniFAAT 2026-2

**Aluna:** Eloísa Brandão  
**RA:** 2325096  
**Disciplina:** DevOps — Centro Universitário UniFAAT  
**Professor:** Alexandre Tavares

Portfólio de atividades da disciplina, do Git e Docker à infraestrutura como código e CI.

## Aulas

| Aula | Projeto | Situação registrada |
|---|---|---|
| [01](aula-01/) | Fundamentos de Git e Docker | Projeto existente |
| [02](aula-02/) | Docker Compose e análise com IA | Projeto existente |
| [03](aula-03/) | Terraform e IAM | Projeto existente |
| [04](aula-04/) | VPC e EC2 Multi-AZ | Projeto existente |
| [05](aula-05/) | RDS PostgreSQL e remote state S3/DynamoDB | Código integrado; evidências de execução AWS continuam pendentes |
| [06](aula-06/) | Módulos Terraform reutilizáveis em dev e staging | Código integrado; arquivos `.tfvars` locais são ignorados pelo Git |
| [07](aula-07/) | API de reserva de salas e Spec-Driven | API integrada e validada localmente; sessão Kiro e relato pessoal pendentes |
| [08](aula-08/) | GitHub Actions, lint, testes e Docker | API e workflow preparados; execução Actions, secret e capturas pendentes |

## Aula 08 — CI

[![CI Aula 08](https://github.com/brandelas/unifaat-devops-portfolio/actions/workflows/ci-aula08.yml/badge.svg)](https://github.com/brandelas/unifaat-devops-portfolio/actions/workflows/ci-aula08.yml)

O workflow fica em [`/.github/workflows/ci-aula08.yml`](.github/workflows/ci-aula08.yml) e valida a API em [`aula-08/technova-api/`](aula-08/technova-api/). Configure o secret de teste `AWS_REGION` no repositório para habilitar a etapa que confirma sua presença. O pipeline não usa nem imprime credenciais AWS.

## Cuidados com credenciais

Não versione arquivos `.tfvars`, estados Terraform, chaves privadas ou `.env`. Use os arquivos `terraform.tfvars.example` como modelos e mantenha valores reais apenas na sua máquina ou em secrets do GitHub.

## Repositórios

- [Portfólio pessoal](https://github.com/brandelas/unifaat-devops-portfolio)
- [Repositório da disciplina](https://github.com/brandelas/devops_20262)
- [Repositório do professor](https://github.com/AleTavares/devops_20262)
