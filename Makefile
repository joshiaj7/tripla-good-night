compose-up:
	docker-compose -f dev/docker-compose.yml --env-file .env up --build -d

compose-down:
	docker-compose -f dev/docker-compose.yml down

compose-start:
	docker-compose -f dev/docker-compose.yml start

compose-stop:
	docker-compose -f dev/docker-compose.yml stop

test:
	bundle exec rake test
