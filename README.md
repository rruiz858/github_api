Project obtains repositories from the Github API that follow the following criteria:
1. have been updated within the last day
2. must have between 1 and 2000 stars
3. must not be forks
4. must specify one of the following OSS license:
  * apache-2.0
  * gpl
  * lgpl
  * mit
  * use ruby or javascript


# Local Setup
Follow the setup in this order

## Environment Variables
This project uses .env to handle env variables. The following env variables are listed in the .env file:
You'll need to fill only the Github related tokens.
### Rails
```
PG_DB_HOST:
PG_DB_PORT:
PG_DB_USER_NAME:
PG_DB_PASSWORD:
```

### Redis
```
REDIS_HOST:
REDIS_PORT:
```

### Github
```
GITHUB_CLIENT_ID:
GITHUB_CLIENT_SECRET:
REDIRECT_URI:
```

The only variables you need to change in the .env are the client_id and client_secret for github.
In order for this project to function, you'll need to create a new OAuth App. It's super simple!
Sign in to Github, go to the following link:
https://github.com/settings/developers.
Once there, click on New OAuth Application. Give the application what ever name you want!
The most important part is the callback url! Set it to:
http://localhost:4667/callback

Once Registered, you'll have a client id and a client secret! Plop those in to the .env file!

Make sure to complete this, otherwise it ain't going to work.

### Docker
It uses docker!
Follow the Docker [Getting Started](https://docs.docker.com/mac/started/) guide to get `docker`, `docker-machine` and `docker-compose`.

Go ahead and clone the project!
1. Set up Volume: `docker volume create --name=postgres-api-data`

2. Run `docker-compose up --build`

3. On a different terminal, cd into the project and run `source setup.sh`  - This will create the database!  Yay!

That should be it!

## Flow
Assuming all the aforementioned steps were completed successfully, you should be able to go visit:
http://localhost:4667

Here, you should be able to click on the `Click Here` link. This will take on a joy ride to the auth process.
Once finished, you'll be redirected over to a beautiful page(with some Ajax magic found in /app/views/calculations/index) showing results.

As soon as you arrive, a background process will kick off to begin calculating the total number of repositories for the last 24 hours (from the time of page load) split into ranges of stars.

The loading modal will disappear once all repositories are found.

To ensure valid data, each time the /calculations page is loaded, all previous background jobs are cleared, and all projects from the database are deleted. - Don't like this but it makes sure that the numbers you see on the screen and the database are up-to-date. Plus, it was the quickest thing I could think of! A cool refresh me button would have also made more sense!

## Database
Once complete, all projects are stored in a database. To get access to the database in one of two ways:

1. docker into the postgres container `docker exec -it github_api_postgres_1 psql -U postgres`
or
2. docker into the rails console via the docker api `docker exec -it github_api_app_1 rails c`

# Notable Gems

## Sidekiq
In order not to have to wait until all of the API calls are complete, Sidekiq is used to asynchronously process
all requests.
All workers can be found under the
`/app/workers` folder of the project.

## OAuth2
A ruby wrapper for the OAuth2 specification
This gem was used to fetch the access_token from Github. Once token obtained, the gem(Used Faraday as its HTTP client) to communicate with Github.
This work can be found under the `/lib/github_api` folder of the project.
There you'll be able to see the work I did to build the request, send the response, and paginate the requests.


## Limitations
Github has a great search ability that returns all repositories with conditions that help refine the search. The problem that I ran into was that:
1. /search endpoint has a rate limit of 30 hits a minute
2. Github has a max per_page of 100
3. Github only provides up to the first 1000 items of any given search

These 3 main reasons limit the time of completion!

### Areas of work
1. Testing Testing Testing! I time boxed this project and man oh man how it hurts to send this without tests
2. Error handling. - Jobs need to restart if error occur.
3. Error handling. - If user revokes token and if job is running, worker will gracefully stop..
4. Better implementation of rate limiting wait approach; I check the rate limit remaining to determine the time of the next request.
5. It's slow....
