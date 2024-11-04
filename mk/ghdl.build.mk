WORK = work/ghdl

DEFGHDLFLAGS = --std=08 -Wall $(GHDLFLAGS)

GHDL = ghdl

all: $(WORK)/work-obj08.cf

run: $(WORK)/work-obj08.cf
	cd "$(WORK)" && $(GHDL) elab-run $(DEFGHDLFLAGS) --workdir=. $(TOPLEVEL) -- --vcd=$(WORK)/$(TOPLEVEL).vcd $(GENERICS)

clean::
	-$(RMTREE) "$(WORK)"

$(WORK):
	$(MKDIR) "$@"

$(WORK)/work-obj08.cf: $(SRC) | $(WORK)
	$(GHDL) analyze $(DEFGHDLFLAGS) --workdir=$(WORK) -fpsl $(firstword $?) $(call up-from,$(firstword $?),$(SRC))
	$(call touch,"$@")
