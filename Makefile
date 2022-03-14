RST := \033[m
BLD := \033[1m
RED := \033[31m
GRN := \033[32m
YLW := \033[33m
BLU := \033[34m
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
