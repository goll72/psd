TESTS = 

SRC = rtl/attrs.vhdl rtl/asm.vhdl \
      rtl/alu/adder.vhdl rtl/alu/alu.vhdl \
      rtl/reg/reg.vhdl rtl/reg/file.vhdl \
      rtl/control.vhdl \
      rtl/mem.vhdl \
      rtl/cpu.vhdl \
      tests/sim.vhdl $(TESTS)

include ../mk/common.build.mk
include ../mk/$(ENV).build.mk

ifeq ($(OS),Windows_NT)
	SIM = ./tools/sim/sim.exe
else
	SIM = ./tools/sim/sim
endif

$(SIM):
	$(MAKE) -C tools/sim

%.bin %.mif: %.s
	$(PYTHON) ./tools/binutils/as.py -f bin:mif $?

DEMOS = demos/add.bin demos/mul.bin demos/fibonacci.bin

%.simdump %.out: %.bin %.in $(SIM)
	$(SIM) -s -n -d 1 -M $*.bin < $*.in > $*.out 2> $*.simdump

%.ok: %.simdump %.out
	$(MAKE) -C . TOPLEVEL=demo_runner GENERICS="-gDEMO_INIT_FILE=$*.bin -gDEMO_SIMDUMP=$*.simdump -gDEMO_IN=$*.in" run

test: $(patsubst %.bin,%.ok,$(DEMOS)) 

clean::
	cd demos; $(RM) *.bin *.mif *.simdump *.out *.ok
