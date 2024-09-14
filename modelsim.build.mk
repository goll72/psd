ifeq ($(OS),Windows_NT)
	PATH := $(PATH):C:/intelFPGA/19.1/modelsim_ase/win32aloem
endif

WORK = simulation/modelsim/gate_work

DEFVFLAGS = $(VFLAGS) -2008 -work $(WORK)

VCOM = vcom 
VSIM = vsim
VLIB = vlib

all: $(WORK)/_lib.qdb
	
$(WORK):
	$(MKDIR) $(dir $@)
	$(VLIB) $@

$(WORK)/_lib.qdb: $(SRC) $(WORK)
	$(VCOM) $(DEFVFLAGS) $(filter-out $?,$(WORK))
	
run:
	$(VSIM) $(TOPLEVEL)

clean:
	$(RMTREE) $(WORK)
