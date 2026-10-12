# Evidências da Aula 08

Capturas reais das execuções do workflow e da configuração do secret:

- `screenshot-pipeline-passing.png` — pipeline verde, incluindo lint, matriz Jest e Docker build/smoke test.
- `screenshot-pipeline-failing.png` — falha intencional nos testes, executada em branch temporária e depois revertida.
- `screenshot-secrets-configured.png` — nome do secret visível; valor oculto.
- `secret-verification-log.png` — passo da CI confirma que o secret está configurado sem exibir seu valor.

Nenhuma captura foi criada artificialmente. As execuções podem ser consultadas na aba Actions do portfólio.
