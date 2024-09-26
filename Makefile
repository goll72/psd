ENV = ...

include common.build.mk

ifneq ($(P),)
init:
	$(MKDIR) "$(P)"
	git worktree add sample sample
	$(call cp,"sample/Makefile","$(P)/Makefile")
	$(call cp,"sample/project.qpf","$(P)/$(notdir $(P)).qpf")
	$(call cp,"sample/project.qsf","$(P)/$(notdir $(P)).qsf")
	$(call cp,"sample/main.vhdl","$(P)/main.vhdl")
	git worktree remove sample
endif
