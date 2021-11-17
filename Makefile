RST := $(shell tput sgr0)
BLD := $(shell tput bold)
RED := $(shell tput setaf 1)
GRN := $(shell tput setaf 2)
YLW := $(shell tput setaf 3)
BLU := $(shell tput setaf 4)
EOL := \n

all:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	$(MAKE) -C pkr/ all
	@printf '${BLD}${YLW}$$${RST} '
	$(MAKE) -C oci/ all
.PHONY: all

clean:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	$(MAKE) -C pkr/ clean
	@printf '${BLD}${YLW}$$${RST} '
	$(MAKE) -C oci/ clean
.PHONY: clean
