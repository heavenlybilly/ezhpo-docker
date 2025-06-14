#!/usr/bin/env bash

set -e

read -p "Введите имя базы данных: " DB_NAME
echo "⚠️  Внимание: если база данных '$DB_NAME' существует — она будет удалена и создана заново!"

read -p "Продолжить? (нажмите любую клавишу, чтобы продолжить, 'n' — чтобы отменить): " CONFIRM
if [ "$CONFIRM" = "n" ]; then
  echo "Операция отменена."
  exit 0
fi

read -e -p "Введите путь к SQL-дампу (на хосте): " DUMP_PATH
echo "Используется дамп: $DUMP_PATH"

DOCKER_COMPOSE="docker compose"

$DOCKER_COMPOSE cp scripts/process-import.sh mysql:/tmp/
$DOCKER_COMPOSE cp "$DUMP_PATH" mysql:/tmp/dump.sql.gz
$DOCKER_COMPOSE exec -T mysql chmod +x /tmp/process-import.sh
$DOCKER_COMPOSE exec -T -w /tmp mysql bash -c "./process-import.sh $DB_NAME dump.sql.gz"

echo "✅ Импорт завершён."