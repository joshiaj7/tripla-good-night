# tripla-good-night
Good night service

# Service Description
Good night service is a service to track your sleep schedule and follow

# Ruby version
- Ruby 3.2.2
- Rails 8.0.2

# System dependencies
- Mysql 8.0
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
User authentication endpoints

| Name    | HTTP Method | Path             | Description                                                                   | Parameters    | Response            |
|---------|-------------|------------------|-------------------------------------------------------------------------------|---------------|---------------------|
| Sign up | POST        | /v1/users/signup | Simulate user sign up. Used to register new user in the service               | name (string) | user name, user id  |
| Log in  | POST        | /v1/users/login  | Simulate user log in. Used to get user token to access core service endpoints | id (integer)  | user token          |


## Core Feature
Endpoints for tripla-good-night core features
All the following endpoints need user token as bearer token

| Name                  | HTTP Method | Path                       | Description                                                                                                        | Parameters                         | Response                                                                                    |
|-----------------------|-------------|----------------------------|--------------------------------------------------------------------------------------------------------------------|------------------------------------|---------------------------------------------------------------------------------------------|
| Schedule clock in     | POST        | /v1/schedules/clock-in     | Clock in schedule for user. Used to clock in (before going to bed) and clock out (after woke up)                   | N/A                                | message that said clock in was successful                                                   |
| Schedule leaderboards | GET         | /v1/schedules/leaderboards | Get a list of user schedules which the current user are following, sorted by sleep duration from highest to lowest | limit and offset for pagination    | List of schedules (shcedule_id, duration_in_seconds, and user_name) and meta for pagination |
| Watchlist follow      | POST        | /v1/watchlists/follow      | Follow other user                                                                                                  | followed_id contains other user id | message that said following in was successful                                               |
| Watchlist unfollow    | POST        | /v1/watchlists/unfollow    | Unfollow other user                                                                                                | followed_id contains other user id | message that said unfollowing in was successful                                             |


# Instructions

1. create a new user via **User Sign Up** endpoint

request example

```sh
curl --location 'http://localhost:3000/v1/users/signup' \
--header 'Content-Type: application/json' \
--data '{
    "name": "test1"
}'
```

response example

```json
{
    "data": {
        "id": 1,
        "name": "test1"
    }
}
```


2. log in by using created user id via **User Log In** endpoint to get user token

request example

```sh
curl --location 'http://localhost:3000/v1/users/login' \
--header 'Content-Type: application/json' \
--data '{
    "id": 1
}'
```

response example

```json
{
    "data": {
        "token": "some-token"
    }
}
```


3. attach the token as bearer token

4. clock in and clock out sleep schedule via **Schedule Clock In** endpoint

request example:

```sh
curl --location --request POST 'http://localhost:3000/v1/schedules/clock-in' \
--header 'Authorization: Bearer some-token' \
```

response example

```json
{
    "data": {
        "message": "clock in successfully"
    }
}
```

5. follow other users via **Watchlists Follow** endpoint

request example

```sh
curl --location 'http://localhost:3000/v1/watchlists/follow' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer some-token' \
--data '{
    "followed_id": 4
}'
```

response example

```json
{
    "data": {
        "message": "followed successfully"
    }
}
```

5. unfollow other users via **Watchlists Unfollow** endpoint

request example

```sh
curl --location 'http://localhost:3000/v1/watchlists/unfollow' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer some-token' \
--data '{
    "followed_id": 2
}'
```

response example

```json
{
    "data": {
        "message": "unfollowed successfully"
    }
}
```

6. get list of following users sleep durations via **Schedule Watchlists** endpoint

request example

```sh
curl --location 'http://localhost:3000/v1/schedules/leaderboards?limit=3&offset=0' \
--header 'Authorization: Bearer some-token'
```

response example

```json
{
    "data": [
        {
            "schedule_id": 28,
            "duration_in_seconds": 31260,
            "user_name": "test3"
        },
        {
            "schedule_id": 31,
            "duration_in_seconds": 30780,
            "user_name": "test4"
        },
        {
            "schedule_id": 27,
            "duration_in_seconds": 29100,
            "user_name": "test4"
        }
    ],
    "meta": {
        "total_count": 3,
        "limit": 3,
        "offset": 0
    }
}
```
