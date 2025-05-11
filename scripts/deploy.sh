#!/usr/bin/env bash
set -euo pipefail

# загрузка .env
if [ ! -f .env ]; then
  echo "Файл .env не найден. Переименуйте .env.example в .env и заполните значения."
  exit 1
fi
source .env

# Создание секретов
kubectl create secret generic telegram-db-secret \
  --from-literal=TELEGRAM_TOKEN="$TELEGRAM_TOKEN" \
  --from-literal=DATABASE_USER="$DATABASE_USER" \
  --from-literal=DATABASE_NAME="$DATABASE_NAME" \
  --from-literal=DATABASE_HOST="$DATABASE_HOST" \
  --from-literal=DATABASE_PASSWORD="$DATABASE_PASSWORD" \
  --from-literal=YOOMONEY_TOKEN="$YOOMONEY_TOKEN" \
  --from-literal=MARZBAN_HOST="$MARZBAN_HOST" \
  --from-literal=MARZBAN_USERNAME="$MARZBAN_USERNAME" \
  --from-literal=MARZBAN_PASSWORD="$MARZBAN_PASSWORD" \
  -o yaml --dry-run=client | kubectl apply -f -

kubectl create secret generic monitor-redis-secret \
  --from-literal=MARZBAN_BASE_URL="$MARZBAN_BASE_URL" \
  --from-literal=MARZBAN_USERNAME="$MARZBAN_USERNAME" \
  --from-literal=MARZBAN_PASSWORD="$MARZBAN_PASSWORD" \
  --from-literal=TELEGRAM_TOKEN="$TELEGRAM_TOKEN" \
  --from-literal=TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID" \
  --from-literal=TELEGRAM_THREAD_CHAT_ID="$TELEGRAM_THREAD_CHAT_ID" \
  --from-literal=REDIS_HOST="$REDIS_HOST" \
  --from-literal=REDIS_PORT="$REDIS_PORT" \
  --from-literal=REDIS_DB="$REDIS_DB" \
  --from-literal=REDIS_PASSWORD="$REDIS_PASSWORD" \
  --from-literal=LOG_LEVEL="$LOG_LEVEL" \
  --from-literal=LANG="$LANG" \
  --from-literal=TELEGRAM_LOGS="$TELEGRAM_LOGS" \
  -o yaml --dry-run=client | kubectl apply -f -

# Применение манифестов
kubectl apply -f manifests/

echo "Деплой завершен."