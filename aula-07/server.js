const express = require('express');
const { randomUUID } = require('node:crypto');

const app = express();
app.use(express.json());

// Persistência intencionalmente em memória, conforme o enunciado da aula.
const salas = [];
const reservas = [];

app.get('/health', (_req, res) => res.json({ status: 'ok' }));

app.post('/salas', (req, res) => {
  const body = req.body && typeof req.body === 'object' ? req.body : {};
  const nome = typeof body.nome === 'string' ? body.nome.trim() : '';
  if (!nome) return res.status(400).json({ erro: 'O nome da sala é obrigatório.' });

  const sala = { id: randomUUID(), nome };
  salas.push(sala);
  return res.status(201).json(sala);
});

app.get('/salas', (_req, res) => res.json(salas));

app.post('/reservas', (req, res) => {
  const body = req.body && typeof req.body === 'object' ? req.body : {};
  const { salaId, funcionario, horario } = body;
  if (![salaId, funcionario, horario].every((value) => typeof value === 'string' && value.trim())) {
    return res.status(400).json({ erro: 'Informe salaId, funcionario e horario.' });
  }
  const instante = Date.parse(horario);
  if (!Number.isFinite(instante)) {
    return res.status(400).json({ erro: 'O horario precisa ser uma data e hora validas.' });
  }
  const horarioNormalizado = new Date(instante).toISOString();
  if (!salas.some((sala) => sala.id === salaId)) {
    return res.status(404).json({ erro: 'Sala não encontrada.' });
  }
  const conflito = reservas.some((reserva) => reserva.salaId === salaId && reserva.horario === horarioNormalizado);
  if (conflito) {
    return res.status(409).json({ erro: 'A sala já está reservada nesse horário.' });
  }

  const reserva = {
    id: randomUUID(),
    salaId,
    funcionario: funcionario.trim(),
    horario: horarioNormalizado,
  };
  reservas.push(reserva);
  return res.status(201).json(reserva);
});

app.delete('/reservas/:id', (req, res) => {
  const index = reservas.findIndex((reserva) => reserva.id === req.params.id);
  if (index === -1) return res.status(404).json({ erro: 'Reserva não encontrada.' });
  reservas.splice(index, 1);
  return res.status(204).end();
});

app.get('/reservas', (req, res) => {
  const funcionario = typeof req.query.funcionario === 'string' ? req.query.funcionario.trim() : '';
  if (!funcionario) return res.status(400).json({ erro: 'Informe o query parameter funcionario.' });
  const resultado = reservas.filter((reserva) => reserva.funcionario.toLowerCase() === funcionario.toLowerCase());
  return res.json(resultado);
});

app.use((err, _req, res, _next) => {
  if (err instanceof SyntaxError && 'body' in err) {
    return res.status(400).json({ erro: 'O corpo da requisição precisa ser JSON válido.' });
  }
  return res.status(500).json({ erro: 'Erro interno inesperado.' });
});

const port = Number(process.env.PORT) || 3000;
if (require.main === module) app.listen(port, () => console.log(`API disponível na porta ${port}`));

module.exports = app;
