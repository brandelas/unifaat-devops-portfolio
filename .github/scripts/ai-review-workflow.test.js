'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');

const workflow = fs.readFileSync(path.join(__dirname, '../workflows/ai-review.yml'), 'utf8');
const ecrWorkflow = fs.readFileSync(path.join(__dirname, '../workflows/build-push-ecr.yml'), 'utf8');
const evalExpression = ['ev', 'al'].join('') + '(input);';

function runAnalyzer(diff, metadata = { complete: true, binaryFilesSkipped: 0 }) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'ai-review-flow-'));
  const diffFile = path.join(dir, 'diff.txt');
  const statusFile = path.join(dir, 'status.json');
  const reportFile = path.join(dir, 'report.md');
  fs.writeFileSync(diffFile, diff);
  fs.writeFileSync(statusFile, JSON.stringify(metadata));
  try {
    const result = spawnSync(process.execPath, [path.join(__dirname, 'ai-review.js')], {
      encoding: 'utf8',
      env: { ...process.env, DIFF_FILE: diffFile, STATUS_FILE: statusFile, REVIEW_RESULT: reportFile },
    });
    return { ...result, report: fs.existsSync(reportFile) ? fs.readFileSync(reportFile, 'utf8') : '' };
  } finally {
    for (const file of [diffFile, statusFile, reportFile]) {
      if (fs.existsSync(file)) fs.unlinkSync(file);
    }
    fs.rmdirSync(dir);
  }
}

test('configuração estática: coleta falha -> análise ignorada, fallback/comentário tentados e gate falha', () => {
  assert.match(workflow, /name: Analisar diff\s+id: analysis\s+if: steps\.collect\.outcome == 'success'/);
  assert.match(workflow, /name: Preparar relatório de falha\s+id: fallback\s+if: always\(\)/);
  assert.match(workflow, /if \[ "\$COLLECT_OUTCOME" = "failure" \];[\s\S]*A coleta do diff falhou/);
  assert.match(workflow, /name: Comentar ou atualizar review\s+if: always\(\) && steps\.collect\.outcome != 'skipped' && steps\.fallback\.outcome == 'success'/);
  assert.match(workflow, /name: Aplicar quality gate\s+if: always\(\) && \(steps\.collect\.outcome == 'failure' \|\| steps\.analysis\.outcome == 'failure'\)/);
});

test('configuração estática mantém falha da análise no quality gate', () => {
  assert.match(workflow, /id: analysis\s+if: steps\.collect\.outcome == 'success'\s+continue-on-error: true/);
  assert.match(workflow, /steps\.analysis\.outcome == 'failure'\)/);
});

test('execução local do analisador: CRITICAL retorna falha para o gate', () => {
  const result = runAnalyzer('+++ b/a.js\n@@ -0,0 +1 @@\n+' + evalExpression + '\n');
  assert.equal(result.status, 1, result.stderr);
});

test('execução local do analisador: somente WARNING e INFO retorna sucesso', () => {
  const todoMarker = ['// TO', 'DO revisar'].join('');
  const result = runAnalyzer('+++ b/a.js\n@@ -0,0 +1,2 @@\n+' + ['console.', 'log("debug");'].join('') + '\n+' + todoMarker + '\n');
  assert.equal(result.status, 0, result.stderr);
});

test('execução local do analisador: diff incompleto publica aviso e falha o gate', () => {
  const result = runAnalyzer('', { complete: false, binaryFilesSkipped: 1, note: 'limite excedido' });
  assert.equal(result.status, 1, result.stderr);
  assert.match(result.report, /Review incompleto/);
  assert.match(result.report, /limite excedido/);
});

test('permissões permanecem restritas à leitura do código e comentário no PR', () => {
  assert.match(workflow, /permissions:\s+contents: read\s+pull-requests: write/);
  assert.doesNotMatch(workflow, /contents: write|actions: write|id-token: write/);
});

test('workflow ECR não publica em push/tag e exige confirmação antes das credenciais', () => {
  assert.match(ecrWorkflow, /on:\s+workflow_dispatch:/);
  assert.doesNotMatch(ecrWorkflow, /^\s*(?:push|release):/m);
  assert.match(ecrWorkflow, /CONFIRM_PUBLISH.*\$\{\{ inputs\.confirm_publish \}\}/);
  assert.match(ecrWorkflow, /CONFIRM_PUBLISH.*PUBLISH/);
  assert.ok(ecrWorkflow.indexOf('Confirmar autorização explícita') < ecrWorkflow.indexOf('Configurar credenciais temporárias'));
  assert.match(ecrWorkflow, /permissions:\s+contents: read/);
});
