#!/bin/bash

DB_NAME="$1"
DUMP_NAME="$2"

if [[ -z "$DB_NAME" || -z $DUMP_NAME ]]; then
    echo "❌ Использование: $0 <имя_бд> <дамп>"
    exit 1
fi

ls -la

echo -e "\n🔵 Извлечение дампа из архива"
rm -f dump.sql
gunzip -c "./$DUMP_NAME" > dump.sql
rm -rf "$DUMP_NAME"

echo -e "\n🔵 Удаление старой БД (если существует)"
mysql -u root -proot -e "drop database if exists \`$DB_NAME\`;"

echo -e "\n🔵 Создание базы данных $DB_NAME"
mysql -u root -proot -e "create database if not exists \`$DB_NAME\`;"

echo -e "\n🔵 Импорт из дампа"
mysql -u root -proot -e "set names utf8;"
mysql -u root -proot -e "set global net_buffer_length=1000000;"
mysql -u root -proot -e "set global max_allowed_packet=1000000000;"
mysql -u root -proot -e "set foreign_key_checks=0;"
mysql -u root -proot -e "set unique_checks=0;"
mysql -u root -proot -e "set autocommit=0;"
mysql -u root -proot "$DB_NAME" < "./dump.sql";

echo -e "\n🔵 Включение ограничений и коммит"
mysql -u root -proot -e "
set foreign_key_checks=1;
set unique_checks=1;
set autocommit=1;
" "$DB_NAME"

echo -e "\n✅ Импорт данных в базу данных $DB_NAME завершен"

rm -f dump.sql
rm -- "$0"