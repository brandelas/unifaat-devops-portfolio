'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');
const { collect, summarizeNumstat, MAX_FILES, MAX_CHANGED_LINES, MAX_DIFF_BYTES } = require('./collect-pr-diff');

test('define limites explícitos para arquivos, linhas e tamanho do diff', () => {
  assert.equal(MAX_FILES, 300);
  assert.equal(MAX_CHANGED_LINES, 20000);
  assert.equal(MAX_DIFF_BYTES, 4 * 1024 * 1024);
});

test('contabiliza binários sem tratá-los como texto analisável', () => {
  assert.deepEqual(summarizeNumstat('4\t2\tapp.js\n-\t-\timage.png\n'), {
    files: 2,
    changedLines: 6,
    binaryFilesSkipped: 1,
  });
});

test('falha do git diff é registrada como análise incompleta sem expor saída do erro', () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'collect-pr-diff-'));
  const diffFile = path.join(dir, 'diff.txt');
  const statusFile = path.join(dir, 'status.json');
  try {
    const metadata = collect('refs/heads/ref-que-nao-existe', 'HEAD', diffFile, statusFile);
    assert.equal(metadata.complete, false);
    assert.match(metadata.note, /Não foi possível coletar o diff/);
    assert.equal(fs.readFileSync(diffFile, 'utf8'), '');
    assert.deepEqual(JSON.parse(fs.readFileSync(statusFile, 'utf8')), metadata);
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
});

test('coletor retorna código diferente de zero quando o diff está incompleto', () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'collect-pr-diff-cli-'));
  const result = spawnSync(process.execPath, [path.join(__dirname, 'collect-pr-diff.js')], {
    encoding: 'utf8',
    env: {
      ...process.env,
      BASE_REF: 'ref-que-nao-existe',
      DIFF_FILE: path.join(dir, 'diff.txt'),
      STATUS_FILE: path.join(dir, 'status.json'),
    },
  });
  try {
    assert.equal(result.status, 1, result.stderr);
    assert.match(result.stdout, /complete=false/);
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
});
