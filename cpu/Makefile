# Used only for simulations
TOPLEVEL =
SRC = main.vhdl

include ../mk/common.build.mk
include ../mk/$(ENV).build.mk

%.bin %.mif: %.s
	$(PYTHON) ./tools/binutils/as.py -f bin:mif $?
