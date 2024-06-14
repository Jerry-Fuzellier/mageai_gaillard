include .env

default: help
CURRENT_UID := $(shell id -u)
INSTALL_STAMP := .install.stamp
POETRY := $(shell command -v poetry 2> /dev/null)


## help		: Print commands help.
.PHONY: help
help : Makefile
	@sed -n 's/^##//p' $<

## up		: Start up containers.
.PHONY: up
up:
	@echo "creating initial directories"
	@echo "Starting up containers for $(PROJECT_NAME)..."
##	docker compose pull
	docker compose up -d --remove-orphans

## down		: Stop containers.
.PHONY: down
down:
	@echo "Downing containers for $(PROJECT_NAME)..."
	@docker compose down

## start		: Start containers without updating.
.PHONY: start
start:
	@echo "Starting containers for $(PROJECT_NAME) from where you left off..."
	@docker compose start

## stop		: Stop containers.
.PHONY: stop
stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker compose stop


## prune		: Remove containers and their volumes.
##		You can optionally pass an argument with the service name to prune single container
##		prune mariadb	: Prune `mariadb` container and remove its volumes.
##		prune mariadb solr	: Prune `mariadb` and `solr` containers and remove their volumes.
.PHONY: prune
prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker compose down -v $(filter-out $@,$(MAKECMDGOALS))

## ps		: list containers
.PHONY:
ps:
	@docker compose ps

## shell		: laucnh shell in django container
.PHONY:
shell:
	docker compose exec $(filter-out $@,$(MAKECMDGOALS)) /bin/bash

## logs		: tail containers logs
##		You can optionally pass an argument with the service name to tail log from a single container
##		logs django	: logs -f `django` container.
##		logs django db	: logs -f `django` and ``db` container.
.PHONY:
logs:
	@docker compose logs -f $(filter-out $@,$(MAKECMDGOALS))

##
## -------- DB specifics commands --------

## mysql		: Connect to database
.PHONY:
mysql:
	docker compose exec central_mysql mysql --user=$(DB_USER) --password=$(DB_PASS) $(DB_NAME)

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
