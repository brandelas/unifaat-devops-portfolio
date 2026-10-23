# Respostas conceituais — Aula 08

## 1. Qual é a diferença entre CI e CD?

Integração contínua (CI) integra alterações frequentemente e executa verificações automatizadas, como lint e testes. Entrega contínua mantém uma versão validada pronta para publicação; implantação contínua publica automaticamente após as verificações e aprovações definidas.

## 2. Por que separar lint, test e build em jobs?

A separação identifica qual etapa falhou, permite controlar dependências com `needs` e impede a construção da imagem se o lint ou os testes falharem. Também facilita acompanhar os resultados na aba Actions.

## 3. Como proteger secrets?

Armazenar valores em GitHub Actions Secrets e referenciá-los como `${{ secrets.NOME }}`. Não registrar valores em arquivos do repositório nem imprimi-los nos logs. Também é importante limitar permissões e usar credenciais de escopo mínimo.

## 4. O que significa o pipeline ficar vermelho?

Uma etapa obrigatória falhou. Deve-se consultar o log do job, identificar a causa, corrigir o código ou a configuração e enviar uma nova alteração. Jobs dependentes não avançam quando uma etapa anterior falha.

## 5. O que faria em um projeto real?

Usaria actions revisadas, dependências fixadas pelo lockfile, permissões mínimas, testes adequados e aprovação para implantações em ambientes compartilhados. Esta pipeline valida a aplicação e não implanta recursos.
