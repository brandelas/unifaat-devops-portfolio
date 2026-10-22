# Aula 09 — Docker Registry e AI Review no CI/CD

Projeto do TF da Aula 09. O registry de destino é Amazon ECR (`us-east-1`); o script `ecr-push.sh` publica as tags SHA e `latest` e, quando o commit atual tem uma git tag semver (`vX.Y.Z`), também publica `X.Y.Z`, `X.Y` e `X`.

## Estrutura

- `technova-api/`: cópia da TechNova API da Aula 08, com Dockerfile multi-stage.
- `ecr-push.sh`: cria/garante o repositório, autentica, builda e publica no ECR.
- `ia-cicd-analise.md`: critérios, padrões, quality gate e limitações do review.
- `screenshots/`: evidências reais do ECR e dos workflows, a preencher após execução.
- `../.github/workflows/ai-review.yml`: workflow GitHub Actions no local reconhecido pelo GitHub.
- `../.github/scripts/ai-review.js`: análise por regras do diff e geração do comentário.
- `../.github/workflows/build-push-ecr.yml`: publicação opcional por GitHub Actions; exige os três secrets temporários do Learner Lab.

## Execução local

A pasta `technova-api/` contém a aplicação e os testes reaproveitados da Aula 08, além do Dockerfile multi-stage otimizado para esta aula. Os checks locais de lint, testes e sintaxe do build passaram.

Em Git Bash ou WSL, execute:

```bash
cd aula-09
docker build -f technova-api/Dockerfile -t technova-api:local technova-api
docker run --rm -p 3000:3000 technova-api:local
curl http://localhost:3000/health
```

O push ao ECR requer uma sessão ativa do AWS Academy Learner Lab e AWS CLI configurada com as credenciais temporárias e `AWS_SESSION_TOKEN`. Quando essa sessão estiver disponível:

```bash
cd aula-09
./ecr-push.sh
```

Para publicar semver, crie e confira uma git tag `vX.Y.Z` no commit da versão e rode o script. Não coloque credenciais AWS em arquivos versionados.

O workflow opcional de publicação exige `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` e `AWS_SESSION_TOKEN` em **Settings → Secrets and variables → Actions**. Esses valores expiram e precisam ser atualizados a cada sessão; por isso, o script local é o fluxo principal do laboratório.

## AI Review

O workflow roda em PRs e novos pushes. A análise por regras posta ou atualiza um comentário no PR; achados CRITICAL falham no job, enquanto WARNING e INFO apenas informam. Esta implementação local não chama Bedrock: segue a opção recomendada no laboratório, com pattern matching.

## Evidências

As screenshots obrigatórias ficam pendentes até o uso autorizado do Learner Lab e a execução de PRs reais. Não há imagens de evidência simuladas neste repositório.
