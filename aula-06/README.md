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

## Configuracao local e protecao de credenciais

Os arquivos `terraform.tfvars.example` documentam as variaveis de cada ambiente sem incluir a senha do banco. Para executar localmente, copie o arquivo de exemplo para `terraform.tfvars` e substitua `CHANGE_ME_LOCALLY` por uma senha temporaria do ambiente de laboratorio. `terraform.tfvars` e ignorado pelo Git; nunca versione senhas, arquivos de state ou credenciais AWS.

```powershell
Copy-Item environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
Copy-Item environments/staging/terraform.tfvars.example environments/staging/terraform.tfvars
```

As configuracoes AWS usam a cadeia padrao do SDK: credenciais temporarias do AWS Academy por variaveis de ambiente ou um profile configurado localmente. Nenhum profile pessoal e fixado nos arquivos versionados.
