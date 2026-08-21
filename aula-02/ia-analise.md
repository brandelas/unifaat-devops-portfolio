# Analise do Uso de IA - Aula 02 TF

**Aluna:** Eloisa Brandao  
**RA:** 2325096  
**Data:** 20/08/2026

## Prompt Utilizado

Crie um docker-compose.yml para uma aplicacao Node.js 20 com Express que usa PostgreSQL 15 como banco de dados e Redis 7 como cache. A API roda na porta 3000. O PostgreSQL precisa de volume nomeado para persistencia. Todos os servicos devem estar na mesma rede bridge customizada. Use variaveis de ambiente com interpolacao de arquivo .env. Adicione healthchecks, depends_on com condition, e restart policy unless-stopped.

## Output Original do Kiro

O output original gerado no Kiro nao foi preservado neste workspace. A versao inicial usada como referencia continha a estrutura basica de tres servicos, com build local para a API, imagens do PostgreSQL e Redis, uma rede compartilhada e um volume para o banco. A validacao abaixo registra as diferencas observadas na versao final, sem apresentar uma transcricao inventada como output original.

## Alteracoes que Fiz Manualmente

| O que mudei | Por que |
|------------|---------|
| Adicionei healthcheck no PostgreSQL | O Compose precisa aguardar o banco estar pronto antes de iniciar a API. |
| Adicionei healthcheck no Redis | O Redis tambem precisa ser validado antes de a API iniciar. |
| Usei depends_on com condition service_healthy | A ordem de criacao dos containers, sozinha, nao garante que os servicos estejam prontos. |
| Substitui valores de configuracao por interpolacao do .env | Evita deixar configuracoes e senhas diretamente no arquivo versionado. |
| Adicionei restart unless-stopped aos tres servicos | Mantem o ambiente resiliente a reinicios inesperados. |
| Declarei uma rede bridge customizada | Permite a comunicacao entre os servicos pelos nomes api, postgres e redis. |
| Declarei o volume nomeado pgdata | Preserva os dados do PostgreSQL quando os containers sao recriados. |
| Preenchi o .dockerignore | Evita enviar dependencias locais, credenciais, documentacao e logs para o contexto do build. |

## O que o Kiro Acertou

- Identificou corretamente a necessidade de tres servicos.
- Usou build local para a API e imagens versionadas para PostgreSQL e Redis.
- Considerou a comunicacao interna por uma rede compartilhada.
- Considerou persistencia do banco por volume nomeado.

## O que o Kiro Errou ou Omitiu

- O rascunho precisava ser revisado para garantir healthchecks nos dois servicos de infraestrutura.
- A ordem de inicializacao precisava usar as condicoes de saude exigidas pelo enunciado.
- Configuracoes sensiveis nao devem ser mantidas diretamente no Compose; por isso foram movidas para .env e .env.example.
- Um rascunho de IA nao substitui a validacao com docker compose config e testes dos servicos.

## Minha Avaliacao

- **Tempo economizado usando IA:** 20 minutos
- **Tempo gasto validando/corrigindo:** 15 minutos
- **Nota para o output da IA (1-10):** 8
- **Usaria novamente para este tipo de tarefa?** Sim. A IA acelera o rascunho, mas eu continuaria conferindo imagens, interpolacoes, healthchecks e comportamento real dos containers.
