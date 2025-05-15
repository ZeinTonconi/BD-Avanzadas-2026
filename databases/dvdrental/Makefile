include .env

up:
	docker-compose --env-file .env up -d

down:
	docker-compose down

psql:
	docker exec -it bdavanzada-postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)
