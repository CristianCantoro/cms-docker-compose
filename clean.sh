#!/bin/bash

docker stop cms-services-test
docker compose down
docker system prune -f
docker volume rm -f cms-docker-compose_cmsdb-data

exit 0

