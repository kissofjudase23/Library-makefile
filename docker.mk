SHELL := /bin/bash

docker_build:
	docker build \
	-t $(TAG) -f $(DOCKERFILE) .

docker_run:
	docker run --rm \
	-v $(HOST_PATH):$(GUEST_PATH) \
	-it $(TAG) $(SHELL)
