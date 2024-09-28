ENV = ...

include common.build.mk

ifneq ($(P),)
init:
	$(MKDIR) "$(P)"
	git worktree add sample sample
	$(call copy,"sample/Makefile","$(P)/Makefile")
	$(call copy,"sample/project.qpf","$(P)/$(notdir $(P)).qpf")
	$(call copy,"sample/project.qsf","$(P)/$(notdir $(P)).qsf")
	$(call copy,"sample/main.vhdl","$(P)/main.vhdl")
	git worktree remove sample
endif
