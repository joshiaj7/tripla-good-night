# tripla-good-night
Good night service

# Service Description
Good night service is a service to track your sleep schedule and follow

# Ruby version
Ruby 3.2.2
Rails 8.0.2

# System dependencies
- Kafka
- Zookeeper

# Setting Up

provision resources
```sh
make compose-up
```

setting up database
```sh
bin/rails db:create 
bin/rails db:migrate  
```

stop resources
```sh
make compose-stop
```

# How to run the test suite

run unit tests
```sh
rspec .
```

# Services (job queues, cache servers, search engines, etc.)

run background job
```sh
bundle exec rake kafka:consume
```

# Endpoints

## Auth
TBD

## Feature
TBD

# Instructions

1. create a new user via **User Sign Up** endpoint

2. log in by using created user id via **User Log In** endpoint to get user token

3. attach the token as bearer token

4. clock in and clock out sleep schedule via **Schedule Clock In** endpoint

5. follow other users via **Schedule Watchlists** endpoint

6. get list of following users sleep durations via **Schedule Watchlists** endpoint

