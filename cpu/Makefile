TESTS = 

SRC = rtl/attrs.vhdl rtl/asm.vhdl rtl/util.vhdl \
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
	$(SIM) -s -n -d 1 -M -N $(patsubst %.dir/,%,$(dir $<)).bin < $*.in > $*.out 2> $*.sim.dump

%.ok: %.sim.dump %.out
	$(MAKE) -C . TOPLEVEL=sim GENERICS="-gDEMO_INIT_FILE=../../$(patsubst %.dir/,%,$(dir $<)).bin -gDEMO_IN=../../$*.in -gDEMO_OUT=../../$*.hdl.out -gDEMO_DUMP=../../$*.hdl.dump" run
	$(call truncate,"$@")
	git diff -U30 --no-index $*.out $*.hdl.out || (cd $(dir $@) && $(RM) "$(notdir $@)")
	git diff -U30 --no-index $*.sim.dump $*.hdl.dump || (cd $(dir $@) && $(RM) "$(notdir $@)")
ifneq ($(TEST_SIM_ABORT_ON_ERROR),)
	$(call if-not-exists,"$@",exit 1)
endif

.PRECIOUS: %.sim.dump %.out %.hdl.dump %.hdl.out

test: $(foreach demo,$(DEMOS),demos/$(demo).bin) \
	  $(patsubst %.in,%.ok,$(DEMO_IN_FILES))

DEMO_GEN_EXT = .ok .sim.dump .out .hdl.dump .hdl.out

defaults::
	@$(call echo,  TEST_SIM_ABORT_ON_ERROR = $(value TEST_SIM_ABORT_ON_ERROR))

ifeq ($(OS),Windows_NT)
clean::
	-cd demos && $(RM) *.bin *.mif
	-for /F "usebackq delims=" %%A in (`dir /b/s $(patsubst %,*%,$(DEMO_GEN_EXT))`) do del %%A
else
clean::
	-cd demos && $(RM) *.bin *.mif
	-$(RM) $(patsubst %,demos/*/*%,$(DEMO_GEN_EXT))
endif
