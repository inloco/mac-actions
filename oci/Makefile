RST := \033[m
BLD := \033[1m
RED := \033[31m
GRN := \033[32m
YLW := \033[33m
BLU := \033[34m
EOL := \n

TAG ?= latest

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
	skopeo copy "dir://$$(pwd)/build" 'docker://ghcr.io/inloco/mactions:${TAG}'
.PHONY: push

latest:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	skopeo copy 'docker://ghcr.io/inloco/mactions:${TAG}' 'docker://ghcr.io/inloco/mactions:latest'
.PHONY: push

build/manifest.json: box2dir.sh ../pkr/output-runner/package.box 
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	./box2dir.sh ../pkr/output-runner/package.box
