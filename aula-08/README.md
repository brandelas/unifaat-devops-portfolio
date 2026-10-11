# Aula 08 — CI da TechNova API

Esta pasta contém a API usada como base para o pipeline da aula 08, conforme o material da disciplina.

- Código e instruções: [`technova-api/README.md`](technova-api/README.md)
- Workflow executado pelo GitHub: [`../.github/workflows/ci-aula08.yml`](../.github/workflows/ci-aula08.yml)
- Evidências visuais: `screenshots/` (a adicionar após execuções reais no GitHub Actions)

O workflow executa ESLint, Jest com coverage e build Docker. Também valida a presença do secret fictício `AWS_REGION`; não armazena nem imprime credenciais de cloud. A pipeline não representa deploy.
