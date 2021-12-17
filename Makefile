# Variables
DOCKER_IMAGE=alvarofpp/antlr4:latest
DOCKER_IMAGE_LINTER=alvarofpp/docker-base-linter
ROOT=$(shell pwd)
LINT_COMMIT_TARGET_BRANCH=origin/main
DOCKER_COMMAND=docker run --rm -v ${ROOT}:/work ${DOCKER_IMAGE}

## Grammar
TARGET_LANGUAGE=Java
TARGET_EXTENSION=java
GRAMMAR=Expr
GRAMMAR_FOLDER=src

# Commands
.PHONY: install-hooks
install-hooks:
	git config core.hooksPath .githooks

.PHONY: antlr
antlr:
	@docker pull ${DOCKER_IMAGE}
	@${DOCKER_COMMAND} antlr -Dlanguage=${TARGET_LANGUAGE} ${GRAMMAR_FOLDER}/${GRAMMAR}.g4

.PHONY: compile
compile:
	@docker pull ${DOCKER_IMAGE}
	@${DOCKER_COMMAND} javac ${GRAMMAR_FOLDER}/${GRAMMAR}*.${TARGET_EXTENSION}

.PHONY: grun
grun:
	@docker pull ${DOCKER_IMAGE}
	@docker run --rm -it \
	-e DISPLAY=$(hostname -I | cut -f1 -d' '):0 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ${ROOT}/src:/work \
	${DOCKER_IMAGE} grun ${GRAMMAR} prog -gui

.PHONY: lint
lint:
	@docker pull ${DOCKER_IMAGE_LINTER}
	@docker run --rm -v ${ROOT}:/app ${DOCKER_IMAGE_LINTER} " \
		lint-commit ${LINT_COMMIT_TARGET_BRANCH} \
		&& lint-markdown \
		&& lint-shell-script \
		&& lint-yaml"
