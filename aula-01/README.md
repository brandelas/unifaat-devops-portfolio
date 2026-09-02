# Aula 01 — Fundamentos de Git e Docker

## O que aprendi

### Git

- Aprendi que o Git serve para guardar o histórico das alterações do projeto.
- Aprendi a usar `git add` para preparar os arquivos e `git commit` para salvar as alterações.
- Aprendi a criar branches para trabalhar em uma parte do projeto sem mexer diretamente na `main`.
- Aprendi a enviar meu projeto para o GitHub usando `git push`.
- Aprendi que o GitHub pode guardar uma cópia do meu projeto e facilitar o trabalho com Git.

### Docker

- Aprendi que o Docker permite executar uma aplicação dentro de um container.
- Entendi que uma imagem é usada para criar um container.
- Aprendi que o `Dockerfile` contém as instruções para criar a imagem da aplicação.
- Aprendi a usar o `.dockerignore` para não copiar arquivos desnecessários para o container.
- Aprendi a criar e executar um container usando `docker build` e `docker run`.

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