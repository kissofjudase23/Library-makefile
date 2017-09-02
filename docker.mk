SHELL := /bin/bash
SHELL_COMMAND :=

# build a docker image from the docker file
docker_build:
	docker build \
		-t $(DOCKER_REPO):$(DOCKER_TAG) \
		-f $(DOCKERFILE) .

# create a container and allocate a pseudo tty for debug
docker_debug_run:
	docker run --rm \
		-v $(HOST_PATH):$(GUEST_PATH) \
		-i --tty $(DOCKER_REPO):$(DOCKER_TAG) $(SHELL)

# create a container and run your test command via bash
docker_internal_run:
	docker run --rm \
	-v $(HOST_PATH):$(GUEST_PATH) \
	-i $(DOCKER_REPO):$(DOCKER_TAG) $(SHELL) $(SHELL_COMMAND)

# remove dangling docker images
docker_dangling_rmi:
	docker images -aq \
		--no-trunc \
		--filter "dangling=true" | xargs docker rmi

# remove all docker images, use this command carefully
docker_all_rmi:
	docker images -aq \
		--no-trunc | xargs docker rmi


