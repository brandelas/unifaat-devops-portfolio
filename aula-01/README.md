# Portfólio DevOps — UniFAAT 2026-2

**Aluno:** Eloísa Brandão  
**RA:** SEU RA  
**Disciplina:** DevOps — Centro Universitário UniFAAT  
**Professor:** Alexandre Tavares  
**Semestre:** 2026-2

## Sobre

Repositório de atividades e projetos da disciplina de DevOps.
Aqui documento minha evolução desde os fundamentos de Git e Docker até pipelines completas de CI/CD.

## Estrutura

- `aula-01/` — Fundamentos de Git e Docker

## Aprendizados

A cada aula, registro neste repositório os principais conceitos e práticas aprendidos durante a disciplina.


# Aula 01 — Fundamentos de Git e Docker

## O que aprendi

### Git

- Aprendi que o Git é um sistema de controle de versão distribuído que permite acompanhar as alterações do projeto e manter um histórico do código.
- Entendi a diferença entre Working Directory, Staging Area e Repository.
- Aprendi a utilizar branches para desenvolver funcionalidades separadamente sem alterar diretamente a branch principal.
- Entendi a importância de commits pequenos e descritivos utilizando Conventional Commits.
- Aprendi como o GitHub funciona como repositório remoto para armazenar e compartilhar o projeto.

### Docker

- Aprendi que containers permitem executar aplicações em ambientes isolados e padronizados.
- Entendi a diferença entre uma imagem Docker e um container.
- Aprendi que o Dockerfile contém as instruções utilizadas para construir uma imagem.
- Entendi a importância do `.dockerignore` para evitar o envio de arquivos desnecessários para a imagem.
- Aprendi a construir imagens e executar containers utilizando os comandos básicos do Docker.

## Comandos Git praticados

- `git status`
- `git add`
- `git commit`
- `git branch`
- `git checkout`
- `git merge`
- `git push`
- `git pull`
- `git remote`
- `git log`

## Comandos Docker praticados

- `docker pull`
- `docker images`
- `docker build`
- `docker run`
- `docker ps`
- `docker logs`
- `docker stop`
- `docker rm`
- `docker exec`

## Como executar este container

```bash
cd aula-01/app
docker build -t portfolio-aula01:1.0 .
docker run -d -p 3000:3000 portfolio-aula01:1.0
curl http://localhost:3000