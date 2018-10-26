#!/bin/bash
docker exec -it github_api_app_1 /app/bin/rails -- db:create
docker exec -it github_api_app_1 /app/bin/rails -- db:migrate
docker exec -it github_api_app_1 /app/bin/rails -- db:seed
