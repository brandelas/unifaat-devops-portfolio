# Processo Spec-Driven — Reserva de Salas | Eloísa Brandão (2325096)

> **Registro honesto:** ainda não conduzi uma sessão Kiro Spec. A API foi implementada e validada localmente nesta preparação; as seções sobre o que o Kiro propôs, erros da IA e reflexão pessoal permanecem pendentes. Não apresente este documento como prova de uma sessão Kiro concluída.

## 1. Como eu dividi o problema

1. Cadastrar sala e validar nome.
2. Listar salas cadastradas.
3. Criar reserva e validar os campos e a sala.
4. Impedir conflito de sala e horário.
5. Cancelar uma reserva pelo identificador.
6. Listar reservas pelo nome do funcionário.

## 2. Requisitos (o quê)

Requisitos do enunciado: API Node.js + Express, armazenamento em memória, rotas para salas e reservas, validação de nome/campos, conflito respondido com erro claro e listagem filtrada por funcionário.

**Resumo da sessão Kiro e correções feitas por mim:** pendente. Não há documento de requisitos gerado em sessão Kiro para relatar.

## 3. Design (como)

Implementação atual: um servidor Express, dois arrays em memória e identificadores UUID. A regra de conflito compara `salaId` e o horário normalizado para UTC; respostas usam códigos HTTP 201, 400, 404, 409 e 204 conforme o caso.

**Design proposto pelo Kiro e decisões que alterei:** pendente até realizar a sessão Spec. Na implementação atual, normalizei horários para UTC para impedir que fusos diferentes mas equivalentes permitam uma reserva duplicada.

## 4. Tarefas (os passos pequenos)

- [x] Criar servidor Express e endpoint de saúde.
- [x] Implementar cadastro e listagem de salas.
- [x] Implementar criação de reserva e validações.
- [x] Bloquear duas reservas para sala e horário iguais.
- [x] Implementar cancelamento e consulta por funcionário.
- [ ] Conduzir as tarefas na sessão Spec do Kiro e guardar evidências reais.

## 5. Implementação e validação

**Executado localmente:** instalação do Express com `npm install` e chamadas HTTP à API na porta 3100 (a porta 3000 já estava ocupada no ambiente). Os resultados observados foram:

- `POST /salas` com nome válido: HTTP 201; `GET /salas`: HTTP 200 e sala listada.
- `POST /reservas` com dados válidos: HTTP 201; horário retornado normalizado em UTC.
- Nova reserva para a mesma sala usando `2026-10-15T13:00:00Z`, equivalente a `2026-10-15T10:00:00-03:00`: HTTP 409.
- `GET /reservas?funcionario=Eloisa`: reserva listada; após cancelar a reserva de `DeleteUser`, a consulta desse funcionário retornou lista vazia.
- `DELETE /reservas/:id`: HTTP 204.
- `POST /salas` sem nome: HTTP 400; sala inexistente na reserva: HTTP 404; horário inválido: HTTP 400.

As validações foram chamadas HTTP locais com PowerShell e `curl.exe`; uma chamada inicial com texto acentuado enviada pelo PowerShell legado teve problema de codificação do cliente. Repeti a validação com dados ASCII; nenhum resultado acima depende daquela chamada.

```bash
npm install
PORT=3100 npm start
curl -i -X POST http://localhost:3100/salas -H "Content-Type: application/json" -d '{"nome":"Sala Ipe"}'
curl -i -X POST http://localhost:3100/reservas -H "Content-Type: application/json" -d '{"salaId":"ID_RETORNADO","funcionario":"Eloisa","horario":"2026-10-12T14:00:00-03:00"}'
curl -i "http://localhost:3100/reservas?funcionario=Eloisa"
curl -i -X DELETE http://localhost:3100/reservas/ID_RETORNADO
```

O HTTP 409 foi confirmado repetindo a reserva com o mesmo `salaId` e um horário com fuso diferente que representa o mesmo instante. Para reproduzir, use o ID retornado pela criação da sala.

## 6. A IA errou em algum momento?

Pendente: esta seção só pode ser preenchida após a sessão real com Kiro. Não vou atribuir erros ou acertos a uma IA que não foi usada nesta implementação.

## 7. Reflexão

Pendente: completar com sua reflexão após conduzir as etapas no Kiro Spec e comparar o processo com um pedido único para gerar o sistema.
