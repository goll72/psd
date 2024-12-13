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
	tectonic -b https://goll.cc/texlive2024/bundle.ttb --keep-logs --keep-intermediates $?

%.bin %.mif: %.s
	$(PYTHON) ./tools/binutils/as.py -f bin:mif $?

%.sim.dump %.out: %.in $(SIM)
	$(MAKE) $(patsubst %.dir/,%,$(dir $<)).bin
	$(SIM) -d 1 -s -n -m $(patsubst %.dir/,%,$(dir $<)).bin < $*.in > $*.out 2> $*.sim.dump

%.ok: %.sim.dump %.out
	$(MAKE) TOPLEVEL=sim GENERICS="-gDEMO_INIT_FILE=../../$(patsubst %.dir/,%,$(dir $<)).bin -gDEMO_IN=../../$*.in -gDEMO_OUT=../../$*.hdl.out -gDEMO_DUMP=../../$*.hdl.dump" run
	$(call truncate,"$@")
	git diff -U30 --no-index $*.out $*.hdl.out || (cd $(dir $@) && $(RM) "$(notdir $@)")
	git diff -U30 --no-index $*.sim.dump $*.hdl.dump || (cd $(dir $@) && $(RM) "$(notdir $@)")
ifneq ($(TEST_SIM_ABORT_ON_ERROR),)
	$(call if-not-exists,"$@",exit 1)
endif

ifeq ($(ENV),quartus)
current.mif.d:
	$(file > current.mif.d,current.mif: $(MIF_FILE))

-include current.mif.d
current.mif: current.mif.d

current.mif:
ifneq ($(_REC),)
	$(if $(filter current.mif.d,$<),$(error MIF_FILE wasn't specified),:)
endif
	$(call copy,$<,current.mif)

ifeq ($(_REC),)
.PHONY: $(SOF_FILE)

$(SOF_FILE):
ifneq ($(MIF_FILE),)
	$(RM) current.mif
	$(RM) current.mif.d
endif
	$(MAKE) _REC=1 $(SOF_FILE)
endif
endif

.PRECIOUS: %.sim.dump %.out %.hdl.dump %.hdl.out

DEMOS = add div mul fibonacci xor prime
DEMO_IN_FILES = $(foreach demo,$(DEMOS),$(wildcard demos/$(demo).dir/*.in))

TEST_SIM_FILES = $(foreach demo,$(DEMOS),demos/$(demo).bin) \
                 $(patsubst %.in,%.ok,$(DEMO_IN_FILES))

test: $(TEST_SIM_FILES)

DEMO_GEN_EXT = .ok .sim.dump .out .hdl.dump .hdl.out

defaults::
	@$(call echo,  TEST_SIM_ABORT_ON_ERROR = $(value TEST_SIM_ABORT_ON_ERROR))

clean::
	-$(RM) *.pdf *.aux *.log
	-$(RM) current.mif current.mif.d
	-cd demos && $(RM) *.bin *.mif
ifeq ($(OS),Windows_NT)
	-for /F "usebackq delims=" %%A in (`dir /b/s $(patsubst %,*%,$(DEMO_GEN_EXT))`) do del %%A
else
	-$(RM) $(patsubst %,demos/*/*%,$(DEMO_GEN_EXT))
endif
