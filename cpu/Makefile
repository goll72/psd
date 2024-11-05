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

SIMROOT = tools/sim

include $(SIMROOT)/defs.mk

ifeq ($(OS),Windows_NT)
	SIM = $(SIMROOT)/sim.exe
else
	SIM = $(SIMROOT)/sim
endif

$(SIM): $(SIMDEPS)
	$(MAKE) -C $(SIMROOT)

%.bin %.mif: %.s
	$(PYTHON) ./tools/binutils/as.py -f bin:mif $?

DEMOS = add mul fibonacci

DEMO_IN_FILES = $(foreach demo,$(DEMOS),$(wildcard demos/$(demo).dir/*.in))

%.sim.dump %.out: %.in $(SIM)
	$(SIM) -s -n -d 1 -M $(patsubst %.dir/,%,$(dir $<)).bin < $*.in > $*.out 2> $*.sim.dump

%.ok: %.sim.dump %.out
	$(MAKE) -C . TOPLEVEL=sim GENERICS="-gDEMO_INIT_FILE=$(patsubst %.dir/,%,$(dir $<)).bin -gDEMO_IN=$*.in -gDEMO_OUT=$*.demo.out -gDEMO_DUMP=$*.demo.dump" run
	$(call touch "$*.ok")
	git diff $*.out $*.demo.out || $(RM) "$*.ok"
	git diff $*.sim.dump $*.demo.dump || $(RM) "$*.ok"

test: $(foreach demo,$(DEMOS),demos/$(demo).bin) \
	  $(patsubst %.in,%.ok,$(DEMO_IN_FILES))

DEMO_GEN_EXT = .sim.dump .out .demo.dump .demo.out
DEMO_GEN_FILES = $(foreach suff,$(DEMO_GEN_EXT),demos/$(demo).dir/*$(suff))

clean::
	$(RM) demos/*.bin demos/*.mif
	@$(RM) $(foreach demo,$(DEMOS),$(DEMO_GEN_FILES))
