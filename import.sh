#!/bin/bash

ENV_FILE="$(dirname "$0")/.env"
if [[ -f "$ENV_FILE" ]]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "❌ Файл .env не найден!"
    exit 1
fi

DB_NAME="$1"
DUMP_NAME="$2"

if [[ -z "$DB_NAME" || -z $DUMP_NAME ]]; then
    echo "❌ Использование: $0 <имя_бд> <дамп>"
    exit 1
fi

echo -e "\n🔵 Извлечение дампа из архива"
rm -f dump.sql
gunzip -c "$DUMP_NAME" > dump.sql
rm -f "$DUMP_NAME"

echo -e "\n🔵 Удаление старой БД (если существует)"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "drop database if exists \`$DB_NAME\`;"

echo -e "\n🔵 Создание базы данных $DB_NAME"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "drop database if exists \`$DB_NAME\`; create database \`$DB_NAME\`;"

echo -e "\n🔵 Отключение проверок для ускорения импорта"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$DB_NAME" -e "
set global innodb_flush_log_at_trx_commit=0;
set global sync_binlog=0;
set foreign_key_checks=0;
set unique_checks=0;
set sql_log_bin=0;"

echo -e "\n🔵 Импорт из дампа"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$DB_NAME" < ./dump.sql;"

echo -e "\n🔵 Включение проверок"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$DB_NAME" -e "
set global innodb_flush_log_at_trx_commit=1;
set global sync_binlog=1;
set foreign_key_checks=1;
set unique_checks=1;
set sql_log_bin=1;"

echo -e "\n✅ Импорт данных в базу данных $DB_NAME завершен"

rm -f dump.sql
rm -f .env
rm -f "$0"
