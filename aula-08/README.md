# Aula 08 — CI da TechNova API

Esta pasta contém a API usada como base para o pipeline da aula 08, conforme o material da disciplina.

- Código e instruções: [`technova-api/README.md`](technova-api/README.md)
- Workflow executado pelo GitHub: [`../.github/workflows/ci-aula08.yml`](../.github/workflows/ci-aula08.yml)
- Evidências reais: [`screenshots/`](screenshots/), incluindo pipeline verde, falha intencional, configuração do secret e log de verificação.
- Respostas conceituais: [`RESPOSTAS.md`](RESPOSTAS.md).

## Capturas solicitadas

| Evidência | Captura |
|---|---|
| Pipeline aprovada no GitHub Actions | [screenshot-pipeline-passing.png](screenshots/screenshot-pipeline-passing.png) |
| Falha intencional da pipeline | [screenshot-pipeline-failing.png](screenshots/screenshot-pipeline-failing.png) |
| Secret `AWS_REGION` configurado, com valor oculto | [screenshot-secrets-configured.png](screenshots/screenshot-secrets-configured.png) |
| Log que confirma a presença do secret sem exibi-lo | [secret-verification-log.png](screenshots/secret-verification-log.png) |

O workflow executa ESLint, Jest com coverage e build Docker. Também valida a presença do secret fictício `AWS_REGION`; não armazena nem imprime credenciais de cloud. A pipeline não representa deploy.
