compose-up:
	docker-compose -f dev/docker-compose.yml --env-file .env up --build -d

compose-down:
	docker-compose -f dev/docker-compose.yml down -v

compose-start:
	docker-compose -f dev/docker-compose.yml start

compose-stop:
	docker-compose -f dev/docker-compose.yml stop

test:
	bundle exec rake test

migrate-from-local:
	cp env.sample .env
	rails db:migrate 
