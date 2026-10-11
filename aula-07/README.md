# API de Reserva de Salas — Aula 07

API REST simples da TechNova, com Express e armazenamento em memória. Os dados são apagados quando o processo é reiniciado, conforme o enunciado.

## Executar

```bash
npm install
npm start
```

A API inicia em `http://localhost:3000`. Rotas: `GET /health`, `POST /salas`, `GET /salas`, `POST /reservas`, `DELETE /reservas/:id` e `GET /reservas?funcionario=NOME`.

## Exemplos

```bash
curl -X POST http://localhost:3000/salas -H "Content-Type: application/json" -d '{"nome":"Sala Ipê"}'
curl http://localhost:3000/salas
curl -X POST http://localhost:3000/reservas -H "Content-Type: application/json" -d '{"salaId":"ID_DA_SALA","funcionario":"Eloísa","horario":"2026-10-12T14:00:00-03:00"}'
curl "http://localhost:3000/reservas?funcionario=Eloísa"
```

Os horários são normalizados para UTC antes de salvar. Assim, duas representações ISO com fusos diferentes que indiquem o mesmo instante também entram em conflito (HTTP 409). Horários inválidos retornam HTTP 400.
