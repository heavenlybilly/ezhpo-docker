#!/bin/bash

ENV_FILE="$(dirname "$0")/.env"
if [[ -f "$ENV_FILE" ]]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "❌ Файл .env не найден!"
    exit 1
fi

DB_NAME="$1"

if [[ -z "$DB_NAME" ]]; then
    echo "❌ Использование: $0 <имя_бд>"
    exit 1
fi

echo ""
echo "🔵 Включение проверок"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$DB_NAME" -e "
set global innodb_flush_log_at_trx_commit=1;
set global sync_binlog=1;
set foreign_key_checks=1;
set unique_checks=1;
set sql_log_bin=1;"
if [[ $? -ne 0 ]]; then
    echo "❌ Ошибка при включении проверок!"
    exit 1
fi
echo ""

echo "✅ База данных $DB_NAME успешно создана и заполнена данными из дампа"

rm -f .env
rm -f "$0"