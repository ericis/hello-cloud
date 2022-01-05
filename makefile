# docker | podman
dev_tool:=docker

docker_image_mkdocs_material_version:=8.1.3
docker_image_mkdocs_material_tag:=our-hello-tasks-mkdocs-material:$(docker_image_mkdocs_material_version)

project_dirs=./src/services/dotnet/webapi \
	./src/services/jvm/kotlin/springboot/webapi \
	./src/services/jvm/java/springboot/webapi \
	./src/services/nodejs/expressjs/webapi

docs_app_port=8000
docs_host_port:=8000

docs_container_name:=our-hello-docs

.DEFAULT_GOAL:=install

all: install

.PHONY: init
init:
ifneq ("$(dev_tool)",$(filter "$(dev_tool)","docker" "podman"))
	$(error The "$@" command target only supports "dev_tool=docker" or "dev_tool=podman")
endif
	@set -eu; \
	prev_dir=$(shell pwd); \
	cd ./src/docker/mkdocs && make install; \
	cd $$prev_dir; \
	$(dev_tool) tag $(docker_image_mkdocs_material_tag) mkdocs;

.PHONY: install-docs
install-docs: init
ifneq ("$(dev_tool)",$(filter "$(dev_tool)","docker" "podman"))
	$(error The "$@" command target only supports "dev_tool=docker" or "dev_tool=podman")
endif
	@set -eu \
	&& $(dev_tool) run \
		--name $(docs_container_name)-$@ \
		--rm \
		-i \
		--volume "$(shell pwd)":/app \
		--workdir /app \
		mkdocs \
		build \
			--clean \
			--site-dir ./docs \
			--config-file ./mkdocs.yml

.PHONY: debug-docs
debug-docs: init
ifneq ("$(dev_tool)",$(filter "$(dev_tool)","docker" "podman"))
	$(error The "$@" command target only supports "dev_tool=docker" or "dev_tool=podman")
endif
	@set -eu \
	&& $(dev_tool) run \
		--name $(docs_container_name)-$@ \
		--rm \
		-i \
		--volume "$(shell pwd)":/app \
		--workdir /app \
		--entrypoint "/bin/ash" \
		mkdocs

.PHONY: start-docs
start-docs: init
ifneq ("$(dev_tool)",$(filter "$(dev_tool)","docker" "podman"))
	$(error The "$@" command target only supports "dev_tool=docker" or "dev_tool=podman")
endif
	@set -eu \
	&& $(dev_tool) run \
		--name $(docs_container_name) \
		--detach \
		--volume "$(shell pwd)":/app \
		--workdir /app \
		--publish $(docs_app_port):$(docs_host_port) \
		mkdocs \
		serve \
			-a 0.0.0.0:$(docs_app_port) \
			--livereload \
			--watch-theme \
			--config-file ./mkdocs.yml
	@echo 'Successfully started: http://localhost:$(docs_host_port)'

.PHONY: stop-docs
stop-docs:
ifneq ("$(dev_tool)",$(filter "$(dev_tool)","docker" "podman"))
	$(error The "$@" command target only supports "dev_tool=docker" or "dev_tool=podman")
endif
	@set -eu \
	&& $(dev_tool) rm --force our-hello-docs

.PHONY: restart-docs
restart-docs: stop-docs start-docs

.PHONY: view-docs-logs
view-docs-logs:
ifneq ("$(dev_tool)",$(filter "$(dev_tool)","docker" "podman"))
	$(error The "$@" command target only supports "dev_tool=docker" or "dev_tool=podman")
endif
	@set -eu \
	&& $(dev_tool) logs \
		--tail 1000 \
		--follow \
		$(docs_container_name)

.PHONY: own-docs
own-docs:
	@set -eu \
	&& sudo chown -R $(shell whoami) ./docs

.PHONY: install
install: install-docs
	@set -eu; \
	for project_dir in $(project_dirs); do \
		prev_dir=$(shell pwd); \
		cd $$project_dir && make $@; \
		cd $$prev_dir; \
	done

.PHONY: start
start: start-docs
	@set -eu; \
	for project_dir in $(project_dirs); do \
		prev_dir=$(shell pwd); \
		cd $$project_dir && make $@; \
		cd $$prev_dir; \
	done

.PHONY: stop
stop: stop-docs
	@set -eu; \
	for project_dir in $(project_dirs); do \
		prev_dir=$(shell pwd); \
		cd $$project_dir && make $@; \
		cd $$prev_dir; \
	done

.PHONY: clean
clean:
	@set -eu; \
	docker rmi -f $(docker images | grep 'our-hello-'); \
	for project_dir in $(project_dirs); do \
		prev_dir=$(shell pwd); \
		cd $$project_dir && make $@; \
		cd $$prev_dir; \
	done

# convenience aliases
build: install
up: start
run: start
serve: start
down: stop
uninstall: clean

.PHONY: sync
sync:
	@git-town sync

.PHONY: main
main:
	@git checkout main \
	&& git-town sync \
	&& git-town prune-branches

.PHONY: pr
pr:
	@git-town sync \
	&& echo "" \
	&& echo "Open a new PR at:" \
	&& echo "$$(git remote get-url origin)/compare/$$(git branch --show-current)?expand=1"

check_projects=./src/docker/aws-cli \
	./src/docker/aws-cli-dotnet-sdk \
	./src/docker/azure-cli \
	./src/docker/heroku-cli \
	./src/docker/mkdocs \
	./src/services/dotnet/webapi \
	./src/services/jvm/java/springboot/webapi \
	./src/services/jvm/kotlin/springboot/webapi \
	./src/services/nodejs/expressjs/webapi

.PHONY: check-versions
check-versions:
	@./check-versions.sh; \
	for project_dir in $(check_projects); do \
		prev_dir=$(shell pwd); \
		echo ''; \
		cd $$project_dir && make $@; \
		cd $$prev_dir; \
	done
