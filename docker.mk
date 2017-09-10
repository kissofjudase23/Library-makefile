
DEFAULT_SHELL ?= "/bin/bash"

# build a docker image from the docker file
docker_build:
	docker build \
		-t $(DOCKER_REPO):$(DOCKER_TAG) \
		-f $(DOCKERFILE) .

# create a container and allocate a pseudo tty for debug
# note: assume the ENTRYPOINT=["/bin/bash", "-c""]
docker_debug_run:
	docker run --rm \
		-v $(HOST_PATH):$(GUEST_PATH) \
		-w $(GUEST_PATH) \
		-i --tty $(DOCKER_REPO):$(DOCKER_TAG) \
		$(DEFAULT_SHELL)

# create a container and run your test command via CMD
# note: CMD should match the setting of ENTRYPOINT in your dockerfile
docker_internal_run:
	docker run --rm \
		-v $(HOST_PATH):$(GUEST_PATH) \
		-w $(GUEST_PATH) \
		-i $(DOCKER_REPO):$(DOCKER_TAG) $(TEST_COMMAND)

# run docker with daemon mode
docker_internal_daemon_run:
	docker run --rm \
	-d \
	-v $(HOST_PATH):$(GUEST_PATH) \
	-w $(GUEST_PATH) \
	-p $(HOST_PORT):$(GUEST_PORT) \
	$(DOCKER_REPO):$(DOCKER_TAG) $(TEST_COMMAND)
# remove dangling docker images
docker_dangling_rmi:
	docker images -aq \
		--no-trunc \
		--filter "dangling=true" | xargs docker rmi

# remove all docker images, use this command carefully
docker_all_rmi:
	docker images -aq \
		--no-trunc | xargs docker rmi


