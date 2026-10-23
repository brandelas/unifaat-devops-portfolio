# Evidências pendentes

Guardar aqui as capturas reais após executar as etapas correspondentes. Não fabricar imagens nem registrar uma execução local como execução do GitHub Actions.

- `ecr-console.png`: repositório `technova-api` e tags SHA, `latest` e semver no ECR.
- `ai-review-comment.png`: comentário do workflow em um PR com achados.
- `ecr-push-ok.png`: saída do script ou execução verde do workflow ECR.
- `quality-gate-block.png`: execução do PR mostrando o job `ai-review` bloqueado por CRITICAL.

Para obter as capturas de AI Review e quality gate, será necessário publicar a branch revisada e abrir um PR de teste. O AI Review roda automaticamente nesse PR; o workflow ECR permanece manual e não será acionado pelo PR. Use apenas valores fictícios no teste CRITICAL e retire o código de teste depois. Antes da captura do ECR, confirme no console que o repositório e as tags ainda estão presentes.

Não criar imagens ilustrativas como se fossem evidências de execução.
