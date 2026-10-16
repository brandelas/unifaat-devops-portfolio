#!/usr/bin/env bash
set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
REPOSITORY="${ECR_REPOSITORY:-technova-api}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="${TECHNOVA_API_DIR:-${SCRIPT_DIR}/technova-api}"

if [[ ! -f "${APP_DIR}/Dockerfile" || ! -f "${APP_DIR}/package.json" || ! -f "${APP_DIR}/server.js" ]]; then
  echo "Erro: a TechNova API não está completa em ${APP_DIR}. Copie a pasta da Aula 08 para aula-09/technova-api." >&2
  exit 2
fi
command -v aws >/dev/null || { echo "Erro: AWS CLI não instalado." >&2; exit 2; }
command -v docker >/dev/null || { echo "Erro: Docker não instalado." >&2; exit 2; }

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
REGISTRY="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
ECR_URI="${REGISTRY}/${REPOSITORY}"
SHA="$(git -C "${APP_DIR}" rev-parse --short HEAD)"
SHA_TAG="sha-${SHA}"
LOCAL_IMAGE="${REPOSITORY}:local"

echo "==> Garantindo repositório ${REPOSITORY} em ${REGION}..."
if ! aws ecr describe-repositories --repository-names "${REPOSITORY}" --region "${REGION}" >/dev/null 2>&1; then
  aws ecr create-repository --repository-name "${REPOSITORY}" --region "${REGION}" >/dev/null
fi

echo "==> Autenticando no ECR..."
aws ecr get-login-password --region "${REGION}" \
  | docker login --username AWS --password-stdin "${REGISTRY}"

echo "==> Construindo imagem multi-stage..."
docker build -f "${APP_DIR}/Dockerfile" -t "${LOCAL_IMAGE}" "${APP_DIR}"

tags=("${SHA_TAG}" "latest")
VERSION_TAG="$(git -C "${APP_DIR}" describe --tags --exact-match 2>/dev/null || true)"
if [[ "${VERSION_TAG}" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  major="${BASH_REMATCH[1]}"
  minor="${BASH_REMATCH[2]}"
  patch="${BASH_REMATCH[3]}"
  tags+=("${major}.${minor}.${patch}" "${major}.${minor}" "${major}")
fi

for tag in "${tags[@]}"; do
  echo "==> Publicando ${ECR_URI}:${tag}..."
  docker tag "${LOCAL_IMAGE}" "${ECR_URI}:${tag}"
  docker push "${ECR_URI}:${tag}"
done

echo "==> Imagem publicada:"
printf '    %s\n' "${tags[@]/#/${ECR_URI}:}"
