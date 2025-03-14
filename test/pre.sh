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
echo "🔵 Удаление старой БД (если существует)"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "drop database if exists \`$DB_NAME\`;"
echo ""

echo "🔵 Создание базы данных $DB_NAME"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "drop database if exists \`$DB_NAME\`; create database \`$DB_NAME\`;"
echo ""

echo "🔵 Отключение проверок для ускорения импорта"
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$DB_NAME" -e "
set global innodb_flush_log_at_trx_commit=0;
set global sync_binlog=0;
set foreign_key_checks=0;
set unique_checks=0;
set sql_log_bin=0;"
echo ""

rm -f "$0"