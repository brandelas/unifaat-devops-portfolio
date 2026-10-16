'use strict';

const fs = require('node:fs');

const diffFile = process.env.DIFF_FILE;
if (!diffFile) throw new Error('Defina DIFF_FILE.');
const diff = fs.readFileSync(diffFile, 'utf8');
const additions = diff.split(/\r?\n/).filter((line) => line.startsWith('+') && !line.startsWith('+++')).map((line) => line.slice(1));
const checks = [
  ['AWS access key', /\bAKIA[0-9A-Z]{16}\b/i],
  ['senha ou token hardcoded', /\b(?:password|passwd|secret|token)\s*[:=]\s*['"`][^'"`]{4,}['"`]/i],
  ['chave privada', /-----BEGIN (?:RSA |EC |DSA )?PRIVATE KEY-----/],
  ['JWT secret', /\bjwt[_-]?secret\s*[:=]/i],
  ['eval()', /\beval\s*\(/],
  ['SQL concatenado em query', /\bquery\s*\([^\n]*(?:['"`][^'"`]*['"`]\s*\+|\+\s*[a-z_$])|\b(?:query|sql)\s*=\s*['"`][^'"`]*(?:SELECT|UPDATE|DELETE|INSERT)[^'"`]*['"`]\s*\+|\b(?:SELECT|UPDATE|DELETE|INSERT)\b[^\n]*\+\s*[a-z_$]/i],
];

const findings = [];
for (const line of additions) {
  for (const [name, pattern] of checks) if (pattern.test(line)) findings.push(name);
}
const unique = [...new Set(findings)];
const report = unique.length
  ? `### 🔒 Security Scan\n\n${unique.map((name) => `- 🔴 CRITICAL: ${name} encontrado em linha adicionada`).join('\n')}`
  : '### 🔒 Security Scan\n\n✅ Nenhum dos padrões de segurança verificados foi encontrado no diff.';
console.log(report);
if (process.env.GITHUB_STEP_SUMMARY) fs.appendFileSync(process.env.GITHUB_STEP_SUMMARY, `${report}\n`);

if (process.env.DOCKERFILE && fs.existsSync(process.env.DOCKERFILE)) {
  const dockerfile = fs.readFileSync(process.env.DOCKERFILE, 'utf8');
  const notes = [];
  if (!/^\s*USER\s+\S+/m.test(dockerfile)) notes.push('WARNING: Dockerfile sem USER não-root.');
  if (/^\s*FROM\s+\S+:latest\s*$/im.test(dockerfile)) notes.push('WARNING: imagem base usa :latest.');
  if (!/^\s*HEALTHCHECK\s+/m.test(dockerfile)) notes.push('INFO: HEALTHCHECK não configurado.');
  const dockerReport = notes.length ? `\n\n### 🐳 Dockerfile\n\n${notes.map((note) => `- ${note}`).join('\n')}` : '\n\n### 🐳 Dockerfile\n\n✅ USER e HEALTHCHECK configurados; nenhuma base :latest detectada.';
  console.log(dockerReport);
  if (process.env.GITHUB_STEP_SUMMARY) fs.appendFileSync(process.env.GITHUB_STEP_SUMMARY, `${dockerReport}\n`);
}

if (unique.length) process.exitCode = 1;
