
config:
	docker compose --env-file .env -f docker-compose.yaml config --quiet
build: config
	docker compose --env-file .env -f docker-compose.yaml build --pull
up: config
	docker compose --env-file .env -f docker-compose.yaml up -d --build --wait --wait-timeout 180
down:
	docker compose --env-file .env -f docker-compose.yaml down
