ifeq ($(OS),Windows_NT)
	PATH := $(PATH):C:/intelFPGA_lite/21.1/quartus/bin64
endif

QUARTUS_PROJECT = $(patsubst %.qpf,%,$(wildcard *.qpf))

SOF_FILE = output_files/$(QUARTUS_PROJECT).sof

all: $(SOF_FILE)

run: $(SOF_FILE)
	quartus_pgm -m jtag -o "p;$(SOF_FILE)"

clean::
	-$(RMTREE) db incremental_db output_files
	$(RM) c5_pin_model_dump.txt *.qws *.qdf *.rpt

netlist:
	quartus_npp $(QUARTUS_PROJECT) --netlist_type=sgate
	qnui $(QUARTUS_PROJECT)

$(SOF_FILE): $(SRC) $(QUARTUS_PROJECT).qpf $(QUARTUS_PROJECT).qsf
	quartus_sh --flow compile $(QUARTUS_PROJECT)
