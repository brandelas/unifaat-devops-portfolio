# Infraestrutura TechNova — Aula 04

Infraestrutura AWS criada com Terraform para executar a API TechNova em uma VPC customizada e preparada para expansao Multi-AZ.

## Arquitetura

```text
Internet
   |
Internet Gateway
   |
VPC 10.0.0.0/16
├── AZ 1
│   ├── Public subnet  10.0.1.0/24 ── EC2 t2.micro (API :3000)
│   └── Private subnet 10.0.2.0/24 ── banco futuro (:5432 interno)
└── AZ 2
    ├── Public subnet  10.0.3.0/24 ── preparada para Load Balancer/EC2
    └── Private subnet 10.0.4.0/24 ── banco futuro
```

As duas subnets publicas usam uma route table com `0.0.0.0/0` para o Internet Gateway. As privadas usam a route table padrao, sem rota direta para a internet. Nao ha NAT Gateway, pois ele gera custo e nao e necessario neste exercicio.

## Recursos criados

| Recurso | Funcao |
|---|---|
| VPC | Isolamento de rede e DNS habilitado |
| 2 subnets publicas e 2 privadas | Alta disponibilidade em duas AZs |
| Internet Gateway e route table publica | Acesso externo controlado da API |
| Security Groups API e banco | Portas 22/3000 e 5432 com regras do enunciado |
| Key Pair e EC2 Amazon Linux 2023 | Acesso SSH e execucao da API Node.js |
| Instance Profile | Credenciais temporarias para a EC2, sem access keys no codigo |

> A AMI Amazon Linux 2023 atualmente selecionada possui snapshot raiz de 30 GB. Por isso o volume EBS da EC2 usa 30 GB `gp2`: a AWS rejeita volumes menores que o snapshot de origem. O valor permanece no limite gratuito informado para o laboratorio.

Todos os recursos que aceitam tags recebem `Name`, `Project`, `Environment`, `ManagedBy` e `Owner` por meio de `local.common_tags`.

## Pre-requisitos

- Terraform >= 1.5
- AWS CLI
- Chave SSH local (a chave privada nunca entra no repositorio)
- Learner Lab AWS Academy ativo, para executar no ambiente da disciplina

## Configuracao segura

Crie a chave, se ainda nao existir:

```powershell
ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/technova-key -N '""'
```

Preencha `terraform.tfvars` localmente. O arquivo ja esta ignorado pelo Git; nao publique chaves, tokens, `terraform.tfstate` ou este arquivo.

```hcl
region                   = "us-east-1"
availability_zones       = ["us-east-1a", "us-east-1b"]
key_pair_name            = "technova-key"
public_key_path          = "C:/Users/SEU_USUARIO/.ssh/technova-key.pub"
technova_api_repo_url    = "https://github.com/SEU_USUARIO/technova-api.git"
owner                    = "SEU-RA"
use_academy_instance_profile = true
create_dedicated_iam_role    = false
```

No AWS Academy, inicie o Learner Lab antes de continuar. Copie as credenciais temporarias para variaveis de ambiente apenas na sessao atual do terminal; nao crie nem envie `aws-creds.sh` ao Git. Confirme a sessao com:

```powershell
aws sts get-caller-identity
```

O Academy bloqueia a criacao de IAM roles. Por isso a configuracao padrao consulta o `LabInstanceProfile` existente. Em uma conta AWS comum, altere `use_academy_instance_profile = false` e `create_dedicated_iam_role = true` para criar a role dedicada com `AmazonS3ReadOnlyAccess`.

## Executar

```powershell
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
terraform show -no-color tfplan | Out-File -Encoding utf8 terraform-plan-output.txt
terraform apply tfplan
```

## Testar

Espere cerca de tres minutos pelo User Data, depois:

```powershell
$apiIp = terraform output -raw ec2_public_ip
curl "http://$apiIp`:3000/"
curl "http://$apiIp`:3000/health"
curl "http://$apiIp`:3000/orders"
ssh -i $HOME/.ssh/technova-key ec2-user@$apiIp "node --version; aws sts get-caller-identity"
```

Guarde apenas as saidas solicitadas como evidencias, revise-as antes de publicar e nunca inclua tokens de sessao. O User Data registra diagnosticos em `/var/log/technova-setup.log` e a API em `/var/log/technova-api.log`.

## Limpeza obrigatoria

Depois das evidencias, remova todos os recursos:

```powershell
terraform destroy
terraform state list
```

O ultimo comando deve retornar vazio. Isso evita custos e e uma evidencia requerida pelo TF.

## Decisoes tecnicas

- Multi-AZ deixa a topologia pronta para um Load Balancer e reduz dependencia de uma unica zona.
- A API fica em subnet publica porque precisa receber requisicoes externas; o banco planejado fica em subnet privada e aceita somente PostgreSQL a partir da VPC.
- A AMI e descoberta por data source, evitando IDs fixos por regiao.
- A EC2 recebe um Instance Profile; access keys AWS nao sao usadas nem armazenadas no Terraform.
