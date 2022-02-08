# General release info
DOCKER_ACCOUNT := boeboe
APP_NAME       := nc-http-server
APP_VERSION    := 1.0.0
ALPINE_VERSION := 3.15.0

BUILD_ARGS     := --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg APP_VERSION=${APP_VERSION}

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build container
	docker build ${BUILD_ARGS} --no-cache -t $(DOCKER_ACCOUNT)/$(APP_NAME) .

run: ## Run container
	docker run -it --rm -p 8080:8080 --name="$(APP_NAME)" $(DOCKER_ACCOUNT)/$(APP_NAME)

publish: ## Tag and publish container
	docker tag $(DOCKER_ACCOUNT)/$(APP_NAME) $(DOCKER_ACCOUNT)/$(APP_NAME):${APP_VERSION}
	docker push $(DOCKER_ACCOUNT)/$(APP_NAME):${APP_VERSION}

release: build publish ## Make a full release
