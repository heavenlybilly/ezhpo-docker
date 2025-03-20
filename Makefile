DOCKER_COMPOSE = docker compose

build:
	$(DOCKER_COMPOSE) build --no-cache

ps:
	$(DOCKER_COMPOSE) ps

down:
	$(DOCKER_COMPOSE) down

up:
	$(DOCKER_COMPOSE) up -d

restart:
	$(DOCKER_COMPOSE) restart

bash:
	$(DOCKER_COMPOSE) exec -it php-apache bash

db:
	$(DOCKER_COMPOSE) exec -it -u root mysql bash

enable:
	@read -p "Enter host name: " HOST_NAME && \
	$(DOCKER_COMPOSE) exec -T php-apache a2ensite $$HOST_NAME && \
	$(DOCKER_COMPOSE) exec -T php-apache service apache2 reload

import-db:
	@read -p "Введите имя базы данных: " DB_NAME && \
	echo "⚠️  Внимание: если база данных '$$DB_NAME' существует — она будет удалена и создана заново!" && \
	read -p "Продолжить? (нажмите любую клавишу, чтобы продолжить, 'n' — чтобы отменить): " CONFIRM && \
	read -e -p "Введите путь к SQL-дампу (на хосте): " && \
	echo $$REPLY && \
	$(DOCKER_COMPOSE) cp import.sh mysql:/tmp/ && \
	$(DOCKER_COMPOSE) cp $$REPLY mysql:/tmp/dump.sql.gz && \
	$(DOCKER_COMPOSE) exec -T mysql chmod +x /tmp/ && \
	$(DOCKER_COMPOSE) exec -T -w /tmp mysql bash -c "./import.sh $$DB_NAME dump.sql.gz"