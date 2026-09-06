Aula 03 — Terraform + IAM Completo
Projeto TechNova

Este projeto implementa uma estrutura de identidade e acesso (IAM) utilizando Terraform e AWS.

O objetivo é aplicar boas práticas de Infrastructure as Code (IaC), organização de acessos por função, reutilização de código e o princípio do menor privilégio.

1. Estrutura IAM

A arquitetura foi dividida em grupos de acordo com as responsabilidades de cada função.

Developers

Grupo:

2325096-technova-developers

Usuários:

Juliana — desenvolvedora
Rafael — Platform Engineering
Lucas — estagiário

Permissões:

Leitura de objetos S3 relacionados ao projeto TechNova
Listagem dos buckets necessários
Bloqueio de operações destrutivas
Platform Engineering

Grupo:

2325096-technova-platform-eng

Usuário:

Rafael

Permissões:

Consultar instâncias EC2
Iniciar e parar instâncias EC2 identificadas pela tag Project = TechNova
Ler, gravar e excluir objetos S3 necessários
Listar buckets necessários
Bloqueio de operações destrutivas

A separação por grupos evita a atribuição direta de permissões aos usuários e facilita a administração dos acessos.

2. Usuários e grupos

Os usuários criados são:

Usuário	Grupo(s)
2325096-juliana-dev	Developers
2325096-rafael-platform	Developers + Platform Engineering
2325096-lucas-intern	Developers

O usuário Rafael pertence aos dois grupos porque possui responsabilidades relacionadas tanto ao desenvolvimento quanto à área de Platform Engineering.

3. Políticas customizadas

Foram criadas três políticas IAM customizadas.

3.1 S3 Read

A política permite:

s3:GetObject
s3:ListBucket

O acesso é limitado aos recursos S3 relacionados ao projeto TechNova.

Essa política é utilizada pelo grupo Developers para permitir acesso de leitura sem conceder permissões de escrita ou administração.

3.2 EC2 + S3

A política permite ao grupo Platform Engineering executar operações controladas em EC2 e S3.

Permissões principais:

ec2:DescribeInstances
ec2:StartInstances
ec2:StopInstances
s3:GetObject
s3:PutObject
s3:DeleteObject
s3:ListBucket

As operações de iniciar e parar instâncias EC2 utilizam uma condição baseada na tag:

Project = TechNova

Dessa forma, as operações são destinadas somente às instâncias identificadas como pertencentes ao projeto.

3.3 Deny Destructive

Foi criada uma política de negação explícita para impedir operações consideradas destrutivas.

Entre as ações bloqueadas estão:

s3:DeleteBucket
s3:DeleteObject
ec2:TerminateInstances
ec2:Delete*
iam:Delete*

Um Deny explícito prevalece sobre permissões Allow, proporcionando uma camada adicional de proteção.

A política é aplicada aos grupos Developers e Platform Engineering.

4. IAM Role para EC2

Foi criada uma IAM Role específica para workloads executados em EC2.

Nome:

2325096-technova-ec2-role

A role possui uma política de confiança que permite que o serviço EC2 assuma a role por meio de:

ec2.amazonaws.com

A role possui permissões específicas para acessar os dados da aplicação armazenados no S3.

O acesso inclui:

s3:GetObject
s3:PutObject
s3:ListBucket

Os recursos são limitados aos buckets relacionados a:

technova-app-data-*

Fluxo da arquitetura:

EC2 → Instance Profile → IAM Role → S3

Essa abordagem evita a necessidade de armazenar Access Keys diretamente na instância EC2.

5. Instance Profile

Foi criado um Instance Profile para conectar a IAM Role às instâncias EC2.

Nome:

2325096-technova-ec2-profile

O Instance Profile permite que uma instância EC2 utilize as permissões da IAM Role de maneira segura, sem necessidade de armazenar credenciais de acesso diretamente no servidor.

6. Variáveis reutilizáveis

O projeto utiliza variáveis para evitar valores desnecessariamente fixos no código.

As principais variáveis são:

project_name
environment
aluno
ra
disciplina
aula

Valores utilizados neste projeto:

Project Name = TechNova
Environment = dev
Aluno = Eloísa Brandão
RA = 2325096
Disciplina = DevOps - UniFAAT 2026-2
Aula = 03

O uso de variáveis facilita a reutilização e padronização da infraestrutura.

7. Tags e padronização

Os recursos que suportam tags utilizam uma estrutura padronizada.

Tags utilizadas:

Project = TechNova
ManagedBy = Terraform
Aluno = Eloísa Brandão
RA = 2325096
Disciplina = DevOps - UniFAAT 2026-2
Aula = 03

A padronização facilita a identificação e o gerenciamento dos recursos da infraestrutura.

8. Princípio do menor privilégio

O princípio do menor privilégio foi aplicado limitando as permissões de cada grupo às atividades necessárias para sua função.

Exemplo 1 — Developers

O grupo Developers possui somente permissões de leitura no S3.

Dessa forma, os desenvolvedores conseguem consultar os dados necessários sem receber permissões de gerenciamento de infraestrutura ou de alteração de instâncias EC2.

Exemplo 2 — Platform Engineering

O grupo Platform Engineering possui permissões adicionais para gerenciamento controlado de EC2 e S3.

As operações de iniciar e parar instâncias EC2 são condicionadas à tag:

Project = TechNova

Isso reduz o risco de alteração acidental de recursos pertencentes a outros projetos.

Além disso, o Deny explícito bloqueia operações destrutivas.

9. Fluxos de acesso
Usuários

O fluxo de autorização dos usuários é:

User → Group → IAM Policy → AWS Resource

Os usuários recebem permissões por meio dos grupos, evitando a criação de permissões individuais diretamente nos usuários.

EC2

O fluxo de acesso da aplicação é:

EC2 → Instance Profile → IAM Role → S3

A EC2 utiliza a IAM Role para acessar os recursos necessários no S3 sem armazenar Access Keys na máquina.

10. Outputs

O projeto possui outputs para facilitar a identificação dos recursos gerenciados pelo Terraform.

São disponibilizados:

Nome do grupo Developers
Nome do grupo Platform Engineering
Nomes dos usuários
ARNs das policies customizadas
ARN da IAM Role da EC2
ARN do Instance Profile

Essas informações podem ser consultadas após um terraform apply utilizando:

terraform output

11. Validação e planejamento

Os principais comandos utilizados no projeto são:

terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
Terraform Init

Inicializa o projeto e instala o provider AWS necessário.

Terraform Validate

Verifica se a configuração Terraform está sintaticamente correta.

Terraform Plan

Apresenta as alterações que o Terraform pretende realizar antes de aplicá-las na AWS.

Terraform Apply

Aplica a infraestrutura planejada na conta AWS.

Terraform Destroy

Remove os recursos gerenciados pelo Terraform quando necessário.

12. Evidência do Terraform Plan

O arquivo:

terraform-plan-output.txt

será utilizado para armazenar a saída real do comando:

terraform plan

Essa evidência permite demonstrar que o plano foi executado e revisado antes da aplicação da infraestrutura.

O arquivo deverá conter o resultado do planejamento realizado pelo Terraform.

13. Segurança e boas práticas

Foram consideradas as seguintes boas práticas:

Utilização de usuários individuais
Separação de permissões por grupos
Políticas customizadas
Princípio do menor privilégio
Restrição de ações por recurso sempre que possível
Uso de Condition para operações EC2
Uso de Deny explícito para operações destrutivas
Uso de IAM Role para workloads EC2
Não armazenamento de Access Keys no código
Não versionamento de arquivos de estado do Terraform
Utilização de .gitignore
Infraestrutura definida como código

O arquivo .gitignore impede o versionamento de arquivos de estado e outros arquivos temporários do Terraform.

## 14. Terraform x Console AWS

O Console AWS permite configurar recursos de maneira visual e pode ser útil para operações pontuais.

No entanto, a criação manual de IAM pelo Console depende de várias configurações realizadas por cliques e pode dificultar a reprodução e o rastreamento das alterações.

O Terraform permite representar a infraestrutura e as permissões como código, possibilitando:

- Versionamento
- Reutilização
- Padronização
- Revisão das alterações
- Reprodutibilidade
- Automação
- Rastreabilidade

Para uma equipe, o Terraform é mais seguro e auditável porque as configurações ficam registradas no código e podem ser revisadas antes da aplicação. Dessa forma, alterações de infraestrutura e permissões ficam documentadas no histórico do Git e podem ser reproduzidas de forma consistente.

Neste projeto, o Terraform foi utilizado para tornar a estrutura IAM reproduzível, documentada e alinhada ao princípio do menor privilégio.

15. Conclusão

A Aula 03 implementa uma estrutura IAM completa para o projeto TechNova utilizando Terraform e AWS.

A solução contempla:

Grupos IAM
Usuários IAM
Memberships
Políticas customizadas
Princípio do menor privilégio
Política de negação explícita
IAM Role para EC2
Instance Profile
Variáveis reutilizáveis
Outputs
Tags padronizadas
Documentação
Evidência de terraform plan

A arquitetura foi organizada para separar responsabilidades e reduzir riscos de acesso excessivo, utilizando Terraform como ferramenta de Infrastructure as Code.