#!/bin/bash

# Инициализация переменных
DB_NAME=""
DUMP_PATH=""

# Разбор аргументов
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -db-name) DB_NAME="$2"; shift ;;
        -dump-path) DUMP_PATH="$2"; shift ;;
        *) echo "Неизвестный параметр: $1"; exit 1 ;;
    esac
    shift
done

# Проверка наличия аргументов
if [[ -z "$DB_NAME" || -z "$DUMP_PATH" ]]; then
    echo "Использование: $0 -db-name <имя_бд> -dump-path <путь_к_дампу>"
    exit 1
fi

echo "Создаем базу данных $DB_NAME..."
mysql -u root -proot -e "drop database if exists \`$DB_NAME\`; create database \`$DB_NAME\`;"

echo "Отключаем проверки для ускорения импорта..."
mysql -u root -proot "$DB_NAME" -e "
set global innodb_flush_log_at_trx_commit=0;
set global sync_binlog=0;
set foreign_key_checks=0;
set unique_checks=0;
set sql_log_bin=0;"

echo "Импортируем дамп..."
mysql -u root -proot "$DB_NAME" < "$DUMP_PATH"

echo "Включаем проверки обратно..."
mysql -u root -proot "$DB_NAME" -e "
set global innodb_flush_log_at_trx_commit=1;
set global sync_binlog=1;
set foreign_key_checks=1;
set unique_checks=1;
set sql_log_bin=1;"

echo "База данных $DB_NAME успешно создана и заполнена данными из $DUMP_PATH."
