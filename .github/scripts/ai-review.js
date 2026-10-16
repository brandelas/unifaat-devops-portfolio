'use strict';

const fs = require('node:fs');

const SEVERITY = Object.freeze({ CRITICAL: '🔴 CRITICAL', WARNING: '🟡 WARNING', INFO: '🔵 INFO' });
const RULES = [
  { pattern: /\b(?:password|passwd|secret|api[_-]?key|access[_-]?token)\s*[:=]\s*['"`][^'"`]{4,}['"`]/i, severity: SEVERITY.CRITICAL, message: 'Possível credencial hardcoded.' },
  { pattern: /\bAKIA[0-9A-Z]{16}\b/, severity: SEVERITY.CRITICAL, message: 'Possível AWS Access Key.' },
  { pattern: /\beval\s*\(/, severity: SEVERITY.CRITICAL, message: 'Uso de eval() pode permitir code injection.' },
  { pattern: /\bexec\s*\([^\n]*(?:\$\{|\+\s*[a-z_$])/i, severity: SEVERITY.CRITICAL, message: 'Possível command injection em exec().' },
  { pattern: /\bquery\s*\([^\n]*(?:['"`][^'"`]*['"`]\s*\+|\+\s*[a-z_$])|\b(?:query|sql)\s*=\s*['"`][^'"`]*(?:SELECT|UPDATE|DELETE|INSERT)[^'"`]*['"`]\s*\+|\b(?:SELECT|UPDATE|DELETE|INSERT)\b[^\n]*\+\s*[a-z_$]/i, severity: SEVERITY.CRITICAL, message: 'Possível SQL injection; prefira parâmetros.' },
  { pattern: /\bconsole\.(?:log|debug|info)\s*\(/, severity: SEVERITY.WARNING, message: 'Log de depuração no código alterado.' },
  { pattern: /\bcatch\s*\([^)]*\)\s*\{\s*\}/, severity: SEVERITY.WARNING, message: 'Bloco catch vazio pode ocultar erros.' },
  { pattern: /\b(?:TODO|FIXME|HACK|XXX)\b/, severity: SEVERITY.INFO, message: 'Marcador de trabalho pendente no código novo.' },
  { pattern: /\b(?:0\.0\.0\.0|INADDR_ANY)\b/, severity: SEVERITY.WARNING, message: 'Binding em todas as interfaces; confirme se é intencional.' },
];

function analyzeDiff(diff) {
  const findings = [];
  let file = '(arquivo desconhecido)';
  let lineNumber = 0;
  for (const line of diff.split(/\r?\n/)) {
    if (line.startsWith('+++ b/')) { file = line.slice(6); continue; }
    if (line.startsWith('@@')) { const hunk = line.match(/\+(\d+)/); if (hunk) lineNumber = Number(hunk[1]); continue; }
    if (line.startsWith('\\')) continue;
    if (line.startsWith('+') && !line.startsWith('+++')) {
      const code = line.slice(1);
      for (const rule of RULES) {
        rule.pattern.lastIndex = 0;
        if (rule.pattern.test(code)) findings.push({ file, line: lineNumber, code: code.trim().slice(0, 120), severity: rule.severity, message: rule.message });
      }
      lineNumber += 1;
    } else if (!line.startsWith('-') && !line.startsWith('---')) lineNumber += 1;
  }
  return findings;
}

function generateReport(findings) {
  const marker = '<!-- technova-ai-review -->';
  if (findings.length === 0) return `${marker}\n## 🤖 AI Code Review — TechNova\n\n✅ **Nenhum problema encontrado!**\n\nO diff passou pelas verificações automatizadas. Este resultado complementa, mas não substitui, o review humano.`;
  const count = (severity) => findings.filter((item) => item.severity === severity).length;
  const rows = findings.map((item) => {
    const code = item.code.replaceAll('|', '\\|').replaceAll('`', '\\`');
    return `| ${item.severity} | \`${item.file}\`:${item.line} | ${item.message} | \`${code}\` |`;
  });
  const gateMessage = count(SEVERITY.CRITICAL) ? '> ⛔ **Achados CRITICAL bloqueiam este PR.** Corrija-os e envie outro push.\n\n' : '';
  return `${marker}\n## 🤖 AI Code Review — TechNova\n\n**Resumo:** ${findings.length} achado(s)\n- 🔴 CRITICAL: ${count(SEVERITY.CRITICAL)}\n- 🟡 WARNING: ${count(SEVERITY.WARNING)}\n- 🔵 INFO: ${count(SEVERITY.INFO)}\n\n${gateMessage}### Achados\n\n| Severidade | Local | Problema | Trecho adicionado |\n|:--:|---|---|---|\n${rows.join('\n')}\n\n---\n*Análise heurística por regras; pode gerar falsos positivos e não substitui revisão humana.*`;
}

function main() {
  const { DIFF_FILE: diffFile, REVIEW_RESULT: resultFile } = process.env;
  if (!diffFile || !resultFile) throw new Error('Defina DIFF_FILE e REVIEW_RESULT.');
  const findings = analyzeDiff(fs.readFileSync(diffFile, 'utf8'));
  fs.writeFileSync(resultFile, generateReport(findings), 'utf8');
  const critical = findings.some((item) => item.severity === SEVERITY.CRITICAL);
  console.log(`Review concluído: ${findings.length} achado(s); critical=${critical}`);
  if (critical) process.exitCode = 1;
}

if (require.main === module) {
  try { main(); } catch (error) { console.error(`Falha na análise: ${error.message}`); process.exitCode = 2; }
}

module.exports = { analyzeDiff, generateReport, SEVERITY };
