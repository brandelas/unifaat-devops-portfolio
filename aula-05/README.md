# Aula 05 - RDS e Remote State

Aluno: Eloísa Brandão
RA: 2325096
Projeto: TechNova

## Objetivos

- Provisionar um banco PostgreSQL gerenciado pelo Amazon RDS.
- Utilizar DB Subnet Group em duas subnets privadas.
- Utilizar uma instância RDS `db.t3.micro`.
- Conectar a EC2 ao RDS PostgreSQL.
- Utilizar Remote State com S3.
- Utilizar DynamoDB para locking do Terraform.

## Arquitetura

A infraestrutura da Aula 05 utiliza:

- VPC `10.0.0.0/16`
- 2 subnets públicas
- 2 subnets privadas
- Internet Gateway
- EC2 `t2.micro` em subnet pública
- RDS PostgreSQL `db.t3.micro` em subnets privadas
- Security Group da EC2
- Security Group do RDS permitindo PostgreSQL somente a partir do Security Group da EC2
- S3 como backend remoto do Terraform
- DynamoDB para locking do state

## RDS

O RDS utiliza:

- PostgreSQL 15
- `db.t3.micro`
- 20 GB `gp2`
- `publicly_accessible = false`
- `multi_az = false`
- armazenamento criptografado
- retenção de backup de 7 dias
- DB Subnet Group com duas subnets privadas

## EC2

A EC2 utiliza:

- Amazon Linux 2023
- `t2.micro`
- subnet pública
- `LabInstanceProfile` do AWS Academy
- Key Pair `technova-aula04`
- cliente PostgreSQL instalado via `user-data.sh.tftpl`

## Remote State

O backend Terraform está configurado para:

- S3
- chave `aula-05/terraform.tfstate`
- criptografia habilitada
- DynamoDB para locking

O bucket e a tabela foram configurados anteriormente no projeto `aula-05-backend`.

## Validação

Foram executados:

```text
terraform init -backend=false
terraform validate
terraform fmt -check -recursive
```

O `terraform validate` confirmou que a configuração Terraform está válida.

A validação do backend remoto e o provisionamento dos recursos AWS dependem de credenciais ativas do AWS Academy Learner Lab.

Durante a validação, o acesso à AWS retornou:

```text
InvalidToken: The provided token is malformed or otherwise invalid.
```

Isso indica que as credenciais disponíveis estavam expiradas ou inválidas no momento do teste.

Não foi executado `terraform apply`.

## Estrutura

```text
aula-05/
|-- .gitignore
|-- .terraform.lock.hcl
|-- backend.tf
|-- ec2.tf
|-- networking.tf
|-- outputs.tf
|-- providers.tf
|-- rds.tf
|-- security-groups.tf
|-- subnets.tf
|-- terraform.tfvars.example
|-- user-data.sh.tftpl
|-- variables.tf
|-- versions.tf
|-- vpc.tf
|-- README.md
`-- modules/
    `-- rds/
        |-- main.tf
        |-- outputs.tf
        `-- variables.tf
```
