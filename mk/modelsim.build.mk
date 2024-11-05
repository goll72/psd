ifeq ($(OS),Windows_NT)
	PATH := $(PATH):C:/intelFPGA/19.1/modelsim_ase/win32aloem
endif

WORK = work/modelsim

DEFVFLAGS = $(VFLAGS) -2008 -work $(WORK)

VCOM = vcom 
VSIM = vsim
VLIB = vlib

all: $(WORK)/_lib.qdb

run: $(WORK)/_lib.qdb
	cd "$(WORK)" && $(VSIM) -work . $(GENERICS) $(TOPLEVEL)

clean::
	-$(RMTREE) "$(WORK)"

$(WORK):
	-@$(MKDIR) "$(dir $@)"
	$(VLIB) "$@"

$(WORK)/_lib.qdb: $(SRC) | $(WORK)
	$(VCOM) $(DEFVFLAGS) $(firstword $?) $(call up-from,$(firstword $?),$(SRC))
