ENV = ...

include common.build.mk

ifneq ($(P),)
init:
	git worktree add sample sample
	$(PYTHON) ./sample/init.py "$(P)"
	git worktree remove sample
endif

download-out:
	$(call curl,https://github.com/goll72/psd/releases/download/v1/out.zip,out.zip)
	$(call unzip,out.zip,.)
