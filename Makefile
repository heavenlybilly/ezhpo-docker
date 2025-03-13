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