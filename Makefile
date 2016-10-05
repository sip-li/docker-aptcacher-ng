NS = vp
NAME = aptcacher-ng
APP_VERSION = 0.8.0
IMAGE_VERSION = 1.0
VERSION = $(APP_VERSION)-$(IMAGE_VERSION)
LOCAL_TAG = $(NS)/$(NAME):$(VERSION)

REGISTRY = callforamerica
ORG = vp
REMOTE_TAG = $(REGISTRY)/$(NAME):$(VERSION)

GITHUB_REPO = docker-aptcacher-ng
DOCKER_REPO = aptcacher-ng
BUILD_BRANCH = master


.PHONY: all build test release shell run start stop rm rmi default

all: build

checkout:
	@git checkout $(BUILD_BRANCH)

build:
	@docker build -t $(LOCAL_TAG) --rm .
	@$(MAKE) tag

tag:
	@docker tag $(LOCAL_TAG) $(REMOTE_TAG)

rebuild:
	@docker build -t $(LOCAL_TAG) --rm --no-cache .

commit:
	@git add -A .
	@git commit

clean-data:
	@-rm -rf data/*

push:
	@git push origin master

shell:
	@docker exec -ti $(NAME) /bin/bash

run:
	@docker run -it --rm --name $(NAME) -h $(NAME).local $(LOCAL_TAG) bash

launch:
	@docker run -d --name $(NAME) -p "3142:3142" $(LOCAL_TAG)

launch-net:
	@docker run -d --name $(NAME) -p "3142:3142" --network=local $(LOCAL_TAG)

launch-persist:
	@docker run -d --name $(NAME) -v "$(shell pwd)/data:/var/cache/apt-cacher-ng" -p "3142:3142" $(LOCAL_TAG)

create-network:
	@docker network create -d bridge local

logs:
	@docker logs $(NAME)

logsf:
	@docker logs -f $(NAME)

start:
	@docker start $(NAME)

kill:
	@docker kill $(NAME)

stop:
	@docker stop $(NAME)

rm:
	@docker rm $(NAME)

rmf:
	@docker rm -f $(NAME)

rmi:
	@docker rmi $(LOCAL_TAG)
	@docker rmi $(REMOTE_TAG)

default: build