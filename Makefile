IMAGE_NAME:=$(if $(IMAGE_NAME),$(IMAGE_NAME),skriptfabrik/node-chromium)
TAG_NAME:=$(if $(TAG_NAME),$(TAG_NAME),local)

.PHONY: default
default: lint build test

.PHONY: lint
lint:
	@echo 'Linting Dockerfile'
	@docker run --rm -i hadolint/hadolint < Dockerfile

.PHONY: build
build:
	@echo "Building Docker image"
	@docker pull ${IMAGE_NAME}:${TAG_NAME} || true
	@docker build --cache-from ${IMAGE_NAME}:${TAG_NAME} --tag ${IMAGE_NAME}:${TAG_NAME} .

.PHONY: test
test:
	@echo "Testing Docker image build"
	@docker run --rm -v $(shell pwd)/bin:/root/bin ${IMAGE_NAME}:${TAG_NAME} sh /root/bin/test-docker-build-with-angular

.PHONY: clean
clean:
	@echo "Cleaning up Docker images"
	-@docker rmi --force $(shell docker images ${IMAGE_NAME}:${TAG_NAME} -q)
