RST := \033[m
BLD := \033[1m
RED := \033[31m
GRN := \033[32m
YLW := \033[33m
BLU := \033[34m
EOL := \n

IMAGE_REGISTRY ?= docker.io
IMAGE_REPOSITORY ?= incognia/macbox
IMAGE_VERSION ?= $(shell git describe --dirty --broken --always)
IMAGE_VARIANT ?= 

all: build/manifest.json
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: all

clean:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR build/
.PHONY: clean

push:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	skopeo copy "dir://$$(pwd)/build" 'docker://${IMAGE_REGISTRY}/${IMAGE_REPOSITORY}:${IMAGE_VERSION}${IMAGE_VARIANT}'
.PHONY: push

latest:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	skopeo copy 'docker://${IMAGE_REGISTRY}/${IMAGE_REPOSITORY}:${IMAGE_VERSION}${IMAGE_VARIANT}' 'docker://${IMAGE_REGISTRY}/${IMAGE_REPOSITORY}:latest'
.PHONY: push

build/manifest.json: box2dir.sh ../pkr/output-runner/package.box 
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	./box2dir.sh ../pkr/output-runner/package.box
