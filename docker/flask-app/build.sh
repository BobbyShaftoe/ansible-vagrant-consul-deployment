#!/usr/bin/env bash

docker login https://docker-registry.aws-halcyon-infra.net

docker build -t flask-app .
docker tag flask-app docker-registry.aws-halcyon-infra.net/flask-app:latest
docker push docker-registry.aws-halcyon-infra.net/flask-app

docker pull redis:alpine
docker tag redis docker-registry.aws-halcyon-infra.net/redis:latest
docker push docker-registry.aws-halcyon-infra.net/redis

