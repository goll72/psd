TESTS = 

SRC = rtl/attrs.vhdl rtl/asm.vhdl rtl/util.vhdl \
      rtl/alu/adder.vhdl rtl/alu/alu.vhdl \
      rtl/reg/reg.vhdl rtl/reg/file.vhdl \
      rtl/control.vhdl \
      rtl/mem.vhdl \
      rtl/cpu.vhdl \
      tests/sim.vhdl $(TESTS)

SOF_FILE_DEPS = current.mif

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

%.pdf: %.tex
	tectonic --keep-intermediates $?

%.bin %.mif: %.s
	$(PYTHON) ./tools/binutils/as.py -f bin:mif $?

%.sim.dump %.out: %.in $(SIM) all
	$(MAKE) $(patsubst %.dir/,%,$(dir $<)).bin
	$(SIM) -s -n -d 1 -M -N $(patsubst %.dir/,%,$(dir $<)).bin < $*.in > $*.out 2> $*.sim.dump

%.ok: %.sim.dump %.out
	$(MAKE) -C . TOPLEVEL=sim GENERICS="-gDEMO_INIT_FILE=../../$(patsubst %.dir/,%,$(dir $<)).bin -gDEMO_IN=../../$*.in -gDEMO_OUT=../../$*.hdl.out -gDEMO_DUMP=../../$*.hdl.dump" run
	$(call truncate,"$@")
	git diff -U30 --no-index $*.out $*.hdl.out || (cd $(dir $@) && $(RM) "$(notdir $@)")
	git diff -U30 --no-index $*.sim.dump $*.hdl.dump || (cd $(dir $@) && $(RM) "$(notdir $@)")
ifneq ($(TEST_SIM_ABORT_ON_ERROR),)
	$(call if-not-exists,"$@",exit 1)
endif

-include current.mif.d
current.mif: current.mif.d

current.mif:
	$(if $<,:,$(error MIF_FILE wasn't specified))
	$(call copy,$<,current.mif)

ifeq ($(ENV),quartus)
ifeq ($(_REC),)
$(SOF_FILE):
ifneq ($(MIF_FILE),)
	$(file > current.mif.d,current.mif: $(MIF_FILE))
endif
	$(MAKE) _REC=1 $(SOF_FILE)
endif
endif

.PRECIOUS: %.sim.dump %.out %.hdl.dump %.hdl.out

DEMOS = add mul fibonacci
DEMO_IN_FILES = $(foreach demo,$(DEMOS),$(wildcard demos/$(demo).dir/*.in))

TEST_SIM_FILES = $(foreach demo,$(DEMOS),demos/$(demo).bin) \
                 $(patsubst %.in,%.ok,$(DEMO_IN_FILES))

test: $(TEST_SIM_FILES)

DEMO_GEN_EXT = .ok .sim.dump .out .hdl.dump .hdl.out

defaults::
	@$(call echo,  TEST_SIM_ABORT_ON_ERROR = $(value TEST_SIM_ABORT_ON_ERROR))

clean::
	-$(RM) report.pdf report.aux
	-$(RM) current.mif current.mif.d
	-cd demos && $(RM) *.bin *.mif
ifeq ($(OS),Windows_NT)
	-for /F "usebackq delims=" %%A in (`dir /b/s $(patsubst %,*%,$(DEMO_GEN_EXT))`) do del %%A
else
	-$(RM) $(patsubst %,demos/*/*%,$(DEMO_GEN_EXT))
endif
