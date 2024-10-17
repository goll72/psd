WORK = work/ghdl

DEFGHDLFLAGS = --std=08 -Wall $(GHDLFLAGS)

GHDL = ghdl

all: $(WORK)/work-obj08.cf

run: $(WORK)/work-obj08.cf
	cd "$(WORK)"; $(GHDL) elab-run $(DEFGHDLFLAGS) --workdir=. $(TOPLEVEL)

clean:
	$(RMTREE) $(WORK)

$(WORK):
	$(MKDIR) "$@"

$(WORK)/work-obj08.cf: $(SRC) | $(WORK)
	$(GHDL) analyze $(DEFGHDLFLAGS) --workdir=$(WORK) $(call up-from,$(firstword $?),$(SRC))
	$(call touch,"$@")
