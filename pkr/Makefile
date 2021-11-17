RST := $(shell tput sgr0)
BLD := $(shell tput bold)
RED := $(shell tput setaf 1)
GRN := $(shell tput setaf 2)
YLW := $(shell tput setaf 3)
BLU := $(shell tput setaf 4)
EOL := \n

BOX_NAME ?= incognia/mactions
PROVIDER ?= vmware_fusion
VAGRANT_HOME ?= $(shell printf "$${VAGRANT_HOME:-$${HOME}/.vagrant.d}")
INSTALL_PATH ?= $(shell printf "${VAGRANT_HOME}/boxes/$$(printf "${BOX_NAME}" | sed 's|/|-VAGRANTSLASH-|g')/0/${PROVIDER}")

all: output-runner/package.box
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: all

install: ${INSTALL_PATH}/metadata.json
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: install

clean:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR output-*/ packer_cache/ *.box
.PHONY: clean

remove:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR ${INSTALL_PATH}/
.PHONY: remove

output-runner/package.box: runner.pkr.hcl
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packer init runner.pkr.hcl
	@printf '${BLD}${YLW}$$${RST} '
	packer build -timestamp-ui runner.pkr.hcl

${INSTALL_PATH}/metadata.json: output-runner/package.box
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR ${INSTALL_PATH}/
	@printf '${BLD}${YLW}$$${RST} '
	mkdir -p ${INSTALL_PATH}/
	@printf '${BLD}${YLW}$$${RST} '
	tar -zxvf output-runner/package.box -C ${INSTALL_PATH}/
