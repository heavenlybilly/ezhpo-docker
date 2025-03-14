DOCKER_COMPOSE = docker-compose -f docker-compose.yml

build:
	$(DOCKER_COMPOSE) build --no-cache

down:
	$(DOCKER_COMPOSE) down

up:
	$(DOCKER_COMPOSE) up -d

restart:
	$(DOCKER_COMPOSE) restart

bash:
	$(DOCKER_COMPOSE) exec -it php-apache bash

db:
	$(DOCKER_COMPOSE) exec -it db bash

enable:
	@read -p "Enter host name: " HOST_NAME && \
	$(DOCKER_COMPOSE) exec -T php-apache a2ensite $$HOST_NAME && \
	$(DOCKER_COMPOSE) exec -T php-apache service apache2 reload

import-db:
	@read -p "Введите имя базы данных: " DB_NAME && \
	echo "⚠️  Внимание: если база данных '$$DB_NAME' существует — она будет удалена и создана заново!" && \
	read -p "Продолжить? (нажмите любую клавишу, чтобы продолжить, 'n' — чтобы отменить): " CONFIRM && \
	read -e -p "Введите путь к SQL-дампу (на хосте): " && \
	gunzip -c $$REPLY > dump.sql && \
	$(DOCKER_COMPOSE) cp .env db:/tmp/.env && \
	$(DOCKER_COMPOSE) cp pre.sh db:/tmp/pre.sh && \
	$(DOCKER_COMPOSE) cp post.sh db:/tmp/post.sh && \
	$(DOCKER_COMPOSE) exec -T db chmod +x /tmp/pre.sh && \
	$(DOCKER_COMPOSE) exec -T db chmod +x /tmp/post.sh && \
	$(DOCKER_COMPOSE) exec -T -w /tmp db bash -c "./pre.sh $$DB_NAME" && \
	echo "🔵 Импорт БД из дампа" && \
	pv dump.sql | $(DOCKER_COMPOSE) exec -T db mysql -u root -proot $$DB_NAME && \
	$(DOCKER_COMPOSE) exec -T -w /tmp db bash -c "./post.sh $$DB_NAME"