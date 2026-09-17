# Aula 06 — Terraform Modules

## Visão geral

Este projeto apresenta uma biblioteca de módulos reutilizáveis em Terraform para provisionar ambientes de infraestrutura da TechNova.

A solução foi organizada em módulos independentes para:

* VPC e rede;
* Security Groups;
* Instâncias EC2;
* Banco de dados PostgreSQL com RDS.

Os módulos são compostos pelos ambientes `dev` e `staging`, permitindo reutilizar a mesma estrutura de infraestrutura com diferentes configurações.

## Arquitetura

A infraestrutura é organizada da seguinte forma:

```text
                    ┌─────────────────────┐
                    │       Ambiente      │
                    │    dev / staging    │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │      Módulo VPC     │
                    │                     │
                    │ VPC + Subnets + IGW │
                    │   + Route Tables    │
                    └──────┬───────┬──────┘
                           │       │
             ┌─────────────┘       └─────────────┐
             ▼                                   ▼
    ┌─────────────────┐                 ┌─────────────────┐
    │  Módulo SG API  │                 │  Módulo SG RDS  │
    │                 │                 │                 │
    │ SSH / Porta 3000│                 │   PostgreSQL    │
    └────────┬────────┘                 └────────┬────────┘
             │                                   │
             ▼                                   ▼
    ┌─────────────────┐                 ┌─────────────────┐
    │   Módulo EC2    │                 │   Módulo RDS    │
    │                 │                 │                 │
    │   API Server    │                 │    PostgreSQL   │
    └─────────────────┘                 └─────────────────┘
```

### Dependências entre módulos

```text
VPC
├── vpc_id ──────────────► Security Groups
├── public_subnet_ids ───► EC2
└── private_subnet_ids ──► RDS

Security Group API
└── sg_id ───────────────► EC2

Security Group RDS
└── sg_id ───────────────► RDS
```

## Estrutura
