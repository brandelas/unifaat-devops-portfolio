# Análise — Docker Registry e IA no CI/CD

## Registry e restrições do ambiente

O ECR foi escolhido porque o exercício prepara imagens para execução na AWS e o Learner Lab permite criar repositórios ECR. O registry usa endpoint por conta e região (`<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com`), autenticação temporária pela AWS CLI e a região `us-east-1`. O Lab não permite criar usuários, grupos ou roles IAM; as credenciais incluem `AWS_SESSION_TOKEN` e expiram ao fim da sessão. O script usa a sessão atual e não grava credenciais no repositório. GHCR e Docker Hub têm endpoints e fluxos de autenticação menos acoplados à conta AWS, mas não atendem ao objetivo de praticar publicação e pull no registry AWS.

## Estratégia de tags

- `sha-<SHA curto>`: rastreia a imagem até o commit que a produziu.
- `latest`: conveniência para obter a publicação mais recente; não é referência imutável.
- `X.Y.Z`, `X.Y` e `X`: aliases publicados somente quando o commit atual tem uma git tag `vX.Y.Z`. A versão completa dá precisão de release; os aliases facilitam escolher a versão mais recente dentro de uma linha.

Em produção, o deploy deve preferir digest ou tag de versão imutável; `latest` não deve ser usado para rollback determinístico.

## Review automatizado

O workflow analisa somente linhas adicionadas pelo PR. O script aplica regras transparentes para credenciais hardcoded e chaves AWS, `eval()`, construção suspeita de comandos, queries SQL concatenadas, `console.log/debug/info`, `catch` vazio, marcadores TODO/FIXME e binding em todas as interfaces. O comentário resume os achados por severidade e inclui arquivo, linha aproximada e trecho reduzido. Um marcador HTML permite atualizar o comentário do bot quando chega outro push.

Apesar do nome AI Review usado pelo exercício, a implementação atual é análise heurística por regex (Opção A do laboratório); não envia o diff a Bedrock ou a outro provedor. Um modelo com Bedrock seria uma extensão e exigiria permissão, credenciais e custos/limites próprios.

## Quality gate e revisão humana

- **CRITICAL:** possível segredo ou injection; o job `ai-review` falha e deve ser configurado como required status check nas regras de proteção da branch para impedir merge.
- **WARNING:** padrão de qualidade ou risco contextual; o workflow passa, mas recomenda revisão.
- **INFO:** sugestão ou marcador pendente; o workflow passa.

O gate não substitui as permissões de branch do GitHub. Revisores humanos devem confirmar contexto, impacto e correção proposta, especialmente em achados críticos.

## Limitações

Regex pode gerar falsos positivos e falsos negativos. O scanner vê apenas linhas adicionadas e não acompanha fluxo de dados, contexto de chamadas, dependências ou comportamento em execução. Pode falhar em variações de sintaxe, código gerado ou secrets ofuscados; uma regra que procura palavras-chave não comprova que um valor é credencial. O job não executa uma análise semântica nem substitui ferramentas como CodeQL, Dependabot, Trivy ou revisão humana. O Security Scan separado procura padrões adicionais e sinais básicos no Dockerfile, também sem análise semântica.

## Evidências de execução

Na execução local em 2026-10-22, o script publicou no repositório ECR `technova-api` as tags `sha-f5121b9`, `latest`, `1.0.0`, `1.0` e `1`, todas apontando para o digest `sha256:0a6729d3aa5136c3521a578d7e385b648fcc5fad88d1004bfecbe8f188e4f1ac`. A imagem `1.0.0` foi baixada do ECR e executada localmente; o endpoint `/health` respondeu `ok`. Lint, os nove testes da API e a verificação de sintaxe também passaram localmente.

O workflow opcional `Build and Push to Amazon ECR` foi acionado pela tag Git `v1.0.0`, mas falhou na configuração das credenciais AWS porque os secrets necessários não estão configurados no GitHub. A publicação pelo script local do Learner Lab foi concluída com sucesso; credenciais temporárias não foram copiadas para o repositório.

Continuam pendentes as capturas do console ECR, do comentário em PR, de uma execução verde no GitHub Actions e do quality gate bloqueando um PR. Os workflows de review e gate dependem de um pull request e não foram executados; nenhum PR foi aberto e nenhum screenshot foi fabricado.
