ifeq ($(ENV),)
$(error Defina ENV para um de: modelsim, nvc, quartus)
endif

ifeq ($(OS),Windows_NT)
	CP = copy
	RM = del
	RMTREE = rd /s /q
	MKDIR = md
	TRUNCATE = copy /b nul 
	link = mklink /H $(2) $(1)
	toupper = $(1)
	touch = copy /b $(1) +,,

	SHELL = cmd.exe
else
	CP = cp
	RM = rm -f
	RMTREE = rm -rf
	MKDIR = mkdir -p
	TRUNCATE = truncate -s 0 
	link = ln -f $(1) $(2)
	toupper = $(shell echo $(1) | tr '[:lower:]' '[:upper:]')
	touch = touch $(1)
endif
