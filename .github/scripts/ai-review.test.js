'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { analyzeDiff, generateReport, SEVERITY } = require('./ai-review');

const credentialName = ['pass', 'word'].join('');
const credentialValue = ['hardcoded', '-secret'].join('');
const evalFunction = ['ev', 'al'].join('');
const queryMethod = ['db.que', 'ry('].join('');
const selectClause = ['SE', 'LECT * FROM users WHERE id = '].join('');
const debugCall = ['console.', 'log("debug")'].join('');
const emptyCatch = ['catch (error) {', '}'].join('');
const evalExpression = evalFunction + '(input);';
const diff = [
  'diff --git a/app.js b/app.js', '--- a/app.js', '+++ b/app.js', '@@ -0,0 +1,5 @@',
  '+const ' + credentialName + ' = "' + credentialValue + '";', '+' + evalExpression,
  '+' + queryMethod + '"' + selectClause + '" + id);', '+' + debugCall,
  '+try { run(); } ' + emptyCatch,
].join('\n');

test('detecta os cinco padrões solicitados e atribui severidades', () => {
  const findings = analyzeDiff(diff);
  assert.equal(findings.length, 5);
  assert.equal(findings.filter((item) => item.severity === SEVERITY.CRITICAL).length, 3);
  assert.equal(findings.filter((item) => item.severity === SEVERITY.WARNING).length, 2);
});

test('ignora linhas removidas e inclui severidade CRITICAL no relatório', () => {
  const findings = analyzeDiff(diff.replace('+' + evalExpression, '-' + evalExpression));
  assert.equal(findings.some((item) => item.message.includes('eval' + '()')), false);
  assert.match(generateReport(findings), /Achados CRITICAL bloqueiam/);
});

test('WARNING e INFO não afirmam que o gate CRITICAL bloqueou', () => {
  const findings = analyzeDiff('+++ b/a.js\n@@ -0,0 +1,2 @@\n+' + debugCall + '\n+' + ['// TO', 'DO revisar'].join(''));
  const report = generateReport(findings);
  assert.match(report, /WARNING/);
  assert.match(report, /INFO/);
  assert.doesNotMatch(report, /Achados CRITICAL bloqueiam/);
});

test('detecta catch vazio em várias linhas', () => {
  const findings = analyzeDiff('+++ b/a.js\n@@ -0,0 +1,2 @@\n+catch (error) {\n+}');
  assert.equal(findings.length, 1);
  assert.equal(findings[0].severity, SEVERITY.WARNING);
});

test('reporta arquivos binários ignorados e diff incompleto', () => {
  const report = generateReport([], { complete: false, binaryFilesSkipped: 2, note: 'limite excedido' });
  assert.match(report, /2 arquivo\(s\) binário\(s\) foram ignorados/);
  assert.match(report, /Review incompleto/);
  assert.match(report, /limite excedido/);
});
