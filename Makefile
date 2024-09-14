ENV = ...

include common.build.mk

ifneq ($(P),)
init:
	$(MKDIR) $(P)
	git worktree add sample sample
	$(CP) sample/Makefile $(P)/Makefile
	$(CP) sample/project.qpf $(P)/$(notdir $(P)).qpf
	$(CP) sample/project.qsf $(P)/$(notdir $(P)).qsf
	$(CP) sample/main.vhdl $(P)/main.vhdl
	git worktree remove sample
endif
