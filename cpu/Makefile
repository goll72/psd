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

CWD := $(realpath .)
SIMROOT = $(CWD)/tools/sim

include $(SIMROOT)/defs.mk

ifeq ($(OS),Windows_NT)
	SIM = sim.exe
else
	SIM = sim
endif

vpath $(SIM) $(SIMROOT)
PATH := $(PATH):$(SIMROOT)

$(SIM): $(SIMDEPS)
	$(MAKE) -C $(SIMROOT)

%.bin %.mif: %.s
	$(PYTHON) ./tools/binutils/as.py -f bin:mif $?

DEMOS = add mul fibonacci

DEMO_IN_FILES = $(foreach demo,$(DEMOS),$(wildcard demos/$(demo).dir/*.in))

%.sim.dump %.out: %.in $(SIM)
	$(SIM) -s -n -d 1 -M $(patsubst %.dir/,%,$(dir $<)).bin < $*.in > $*.out 2> $*.sim.dump

%.ok: %.sim.dump %.out
	$(MAKE) -C . TOPLEVEL=sim GENERICS="-gDEMO_INIT_FILE=../../$(patsubst %.dir/,%,$(dir $<)).bin -gDEMO_IN=../../$*.in -gDEMO_OUT=../../$*.demo.out -gDEMO_DUMP=../../$*.demo.dump" run
	$(call touch,"$@")
	git diff $*.out $*.demo.out || $(RM) "$@"
	git diff $*.sim.dump $*.demo.dump || $(RM) "$@"

test: $(foreach demo,$(DEMOS),demos/$(demo).bin) \
	  $(patsubst %.in,%.ok,$(DEMO_IN_FILES))

DEMO_GEN_EXT = .sim.dump .out .demo.dump .demo.out
DEMO_GEN_FILES = $(foreach suff,$(DEMO_GEN_EXT),demos/$(demo).dir/*$(suff))

ifeq ($(OS),Windows_NT)
clean::
	-cd demos && $(RM) *.bin *.mif
	-@for /F "usebackq delims=" %A in (`dir /b/s *.sim.dump *.out *.demo.dump *.demo.out *.ok`) do del %A
else
clean::
	-cd demos && $(RM) *.bin *.mif
	-$(RM) demos/*/*.sim.dump demos/*/*.out demos/*/*.demo.dump demos/*/*.out demos/*/*.ok
endif
