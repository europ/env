default:
	@cat ./Makefile

build:
	@# https://docs.docker.com/build/buildkit/
	DOCKER_BUILDKIT=1 \
	docker-compose build --pull --no-cache --force-rm

run:
	docker-compose run --rm ansible
