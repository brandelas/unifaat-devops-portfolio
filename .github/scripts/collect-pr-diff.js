'use strict';

const fs = require('node:fs');
const { execFileSync } = require('node:child_process');

const MAX_FILES = 300;
const MAX_CHANGED_LINES = 20000;
const MAX_DIFF_BYTES = 4 * 1024 * 1024;

function summarizeNumstat(numstat) {
  const summary = { files: 0, changedLines: 0, binaryFilesSkipped: 0 };
  for (const row of numstat.split(/\r?\n/).filter(Boolean)) {
    const [added, removed] = row.split('\t');
    summary.files += 1;
    if (added === '-' || removed === '-') summary.binaryFilesSkipped += 1;
    else summary.changedLines += Number(added) + Number(removed);
  }
  return summary;
}

function collect(baseRef, headRef, diffFile, statusFile) {
  const metadata = { complete: true, binaryFilesSkipped: 0, files: 0, changedLines: 0, note: '' };
  try {
    const range = baseRef + '...' + headRef;
    const numstat = execFileSync('git', ['diff', '--numstat', '--no-ext-diff', range, '--'], { encoding: 'utf8', maxBuffer: 2 * 1024 * 1024, stdio: ['ignore', 'pipe', 'ignore'] });
    Object.assign(metadata, summarizeNumstat(numstat));
    if (metadata.files > MAX_FILES || metadata.changedLines > MAX_CHANGED_LINES) {
      metadata.complete = false;
      metadata.note = 'Diff excede o limite de ' + MAX_FILES + ' arquivos ou ' + MAX_CHANGED_LINES + ' linhas alteradas; reduza o PR para análise.';
      fs.writeFileSync(diffFile, '', 'utf8');
    } else {
      const diff = execFileSync('git', ['diff', '--no-ext-diff', '--unified=0', range, '--'], { encoding: 'utf8', maxBuffer: MAX_DIFF_BYTES + 1, stdio: ['ignore', 'pipe', 'ignore'] });
      if (Buffer.byteLength(diff, 'utf8') > MAX_DIFF_BYTES) {
        metadata.complete = false;
        metadata.note = 'Diff excede o limite de ' + MAX_DIFF_BYTES + ' bytes; reduza o PR para análise.';
        fs.writeFileSync(diffFile, '', 'utf8');
      } else {
        fs.writeFileSync(diffFile, diff, 'utf8');
      }
    }
  } catch (error) {
    metadata.complete = false;
    metadata.note = 'Não foi possível coletar o diff com segurança; verifique a faixa de commits e os limites do runner.';
    fs.writeFileSync(diffFile, '', 'utf8');
  }
  fs.writeFileSync(statusFile, JSON.stringify(metadata, null, 2), 'utf8');
  return metadata;
}

if (require.main === module) {
  const { BASE_REF, HEAD_REF = 'HEAD', DIFF_FILE, STATUS_FILE } = process.env;
  if (!BASE_REF || !DIFF_FILE || !STATUS_FILE) {
    console.error('Defina BASE_REF, DIFF_FILE e STATUS_FILE.');
    process.exitCode = 2;
  } else {
    const result = collect('origin/' + BASE_REF, HEAD_REF, DIFF_FILE, STATUS_FILE);
    process.stdout.write('Diff: complete=' + result.complete + ', files=' + result.files + ', binary=' + result.binaryFilesSkipped + ', lines=' + result.changedLines + '\n');
    if (!result.complete) process.exitCode = 1;
  }
}

module.exports = { collect, summarizeNumstat, MAX_FILES, MAX_CHANGED_LINES, MAX_DIFF_BYTES };
