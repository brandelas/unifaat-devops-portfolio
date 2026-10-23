# Aula 09 — Docker Registry e AI Review no CI/CD

Projeto do TF da Aula 09. O registry de destino é Amazon ECR (`us-east-1`); o script `ecr-push.sh` publica as tags SHA e `latest` e, quando o commit atual tem uma git tag semver (`vX.Y.Z`), também publica `X.Y.Z`, `X.Y` e `X`.

## Estrutura

- `technova-api/`: cópia da TechNova API da Aula 08, com Dockerfile multi-stage.
- `ecr-push.sh`: cria/garante o repositório, autentica, builda e publica no ECR.
- `ia-cicd-analise.md`: critérios, padrões, quality gate e limitações do review.
- `screenshots/`: evidências reais do ECR e dos workflows, a preencher após execução.
- `../.github/workflows/ai-review.yml`: workflow GitHub Actions no local reconhecido pelo GitHub.
- `../.github/scripts/ai-review.js`: análise por regras do diff e geração do comentário.
- `../.github/workflows/build-push-ecr.yml`: publicação manual por GitHub Actions, com confirmação textual `PUBLISH`; exige os três secrets temporários do Learner Lab e o ambiente `ecr-publish`.

## Execução local

A pasta `technova-api/` contém a aplicação e os testes reaproveitados da Aula 08, além do Dockerfile multi-stage otimizado para esta aula. Nesta validação local passaram ESLint, os nove testes da API e a checagem de sintaxe. Os testes do AI Review e do fluxo estático também passaram; não simulam o GitHub Actions.

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

O workflow de publicação só pode ser iniciado manualmente. Antes de usar, configure `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` e `AWS_SESSION_TOKEN` em **Settings → Secrets and variables → Actions**, atualize-os a cada sessão do Learner Lab e configure revisores no ambiente `ecr-publish`. O despacho exige digitar `PUBLISH`. O script local continua sendo o fluxo principal do laboratório; não faça push de imagens durante testes.

## AI Review

O workflow roda em PRs abertos, reabertos e atualizados. A coleta limita tamanho e quantidade do diff; binários são contabilizados e omitidos da análise. Falha de coleta ou análise gera fallback para comentário quando possível e reprova o job. Achados CRITICAL também falham; WARNING e INFO, isoladamente, passam. Esta implementação usa pattern matching e não chama Bedrock.

Os testes dos scripts podem ser executados com `node --test .github/scripts/*.test.js`. O teste do fluxo do workflow verifica estaticamente as condições do YAML e executa o analisador local; ele não simula o GitHub Actions nem comprova que o comentário ou o quality gate remoto funcionaram.

## Evidências

O script publicou `sha-f5121b9`, `latest`, `1.0.0`, `1.0` e `1` no ECR. A imagem `1.0.0` foi baixada e executada localmente; `/health` respondeu `ok`. ESLint, os nove testes da API e a verificação de sintaxe passaram. Uma execução anterior do workflow automático na tag `v1.0.0` falhou por falta dos secrets AWS. Para evitar publicação acidental, o workflow foi alterado para disparo manual com confirmação; essa versão ainda precisa ser publicada e validada no GitHub.

As screenshots do console ECR, de um comentário de AI Review, do quality gate bloqueando e de uma execução do workflow no GitHub Actions ainda estão pendentes. AI Review e quality gate dependem de um pull request; não foram executados e nenhum PR foi aberto. Não há imagens de evidência simuladas neste repositório.
