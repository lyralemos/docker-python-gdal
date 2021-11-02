GDAL_VERSION ?= 3.0.4
PYTHON_VERSION ?= 3.8
BASE_IMAGE ?= python:$(PYTHON_VERSION)-slim-bullseye
DOCKER_REPO ?= lyralemos/python-gdal
IMAGE ?= $(DOCKER_REPO):py$(PYTHON_VERSION)-gdal$(GDAL_VERSION)

image:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--push \
		--build-arg GDAL_VERSION=$(GDAL_VERSION) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--no-cache \
		-t $(IMAGE) .

test:
	docker run --rm $(IMAGE)

lint:
	docker run \
		--rm \
		-v `pwd`/.dockerfilelintrc:/.dockerfilelintrc \
		-v `pwd`/Dockerfile:/Dockerfile \
		replicated/dockerfilelint /Dockerfile

push-image:
	docker push $(IMAGE)

.PHONY: image test lint push-image
