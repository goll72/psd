ifeq ($(OS),Windows_NT)
	PATH := $(PATH):C:/intelFPGA_lite/21.1/quartus/bin64
endif

QUARTUS_PROJECT = $(patsubst %.qpf,%,$(wildcard *.qpf))

all: output_files/$(QUARTUS_PROJECT).sof

run: output_files/$(QUARTUS_PROJECT).sof
	quartus_pgm -m jtag -o "p;output_files/$(QUARTUS_PROJECT).sof"

clean::
	-$(RMTREE) db incremental_db output_files
	$(RM) c5_pin_model_dump.txt *.qws *.qdf *.rpt

netlist:
	quartus_npp $(QUARTUS_PROJECT) --netlist_type=sgate
	qnui $(QUARTUS_PROJECT)

output_files/$(QUARTUS_PROJECT).sof: $(SRC) $(QUARTUS_PROJECT).qpf $(QUARTUS_PROJECT).qsf
	quartus_sh --flow compile $(QUARTUS_PROJECT)
