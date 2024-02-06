# Variables
DOCKER_IMAGE=alvarofpp/antlr4:latest
DOCKER_IMAGE_LINTER=alvarofpp/linter:latest
ROOT=$(shell pwd)
LINT_COMMIT_TARGET_BRANCH=origin/main
DOCKER_COMMAND=docker run --rm -u $(id -u) -v ${ROOT}:/work ${DOCKER_IMAGE}

## Grammar
TARGET_LANGUAGE=Java
TARGET_EXTENSION=java
GRAMMAR=Expr
GRAMMAR_FOLDER=src

# Commands
.PHONY: init
init:
	@${DOCKER_COMMAND} bash ./init.sh

.PHONY: install-hooks
install-hooks:
	git config core.hooksPath .githooks

.PHONY: antlr
antlr: pull
	@${DOCKER_COMMAND} antlr -Dlanguage=${TARGET_LANGUAGE} ${GRAMMAR_FOLDER}/${GRAMMAR}.g4

.PHONY: compile
compile: pull
	@${DOCKER_COMMAND} javac ${GRAMMAR_FOLDER}/${GRAMMAR}*.${TARGET_EXTENSION}

.PHONY: grun
grun: pull
	@docker run --rm -u $(id -u) -it \
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

.PHONY: pull
pull:
	@docker pull ${DOCKER_IMAGE}
