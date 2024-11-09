ifeq ($(ENV),)
$(error Defina ENV para um de: ghdl, modelsim, nvc, quartus)
endif


# Taken from gmtt - GNU Make Table Toolkit (https://github.com/markpiffer/gmtt)
#
# Copyright (c) 2017-2024 Mark Piffer
space := $(strip) $(strip)#

-separator := ¤# character 164, used in various functions to compose/decompose strings
-never-matching := ¥# character 165, this is used as a list element that should never appear as a real element

## Return first part of _list_ up to but excluding the first occurrence of _word_.
## If _word_ is not in _list_, the whole list is returned.
up-to = $(if $(filter $1,$(firstword $2)),,$(strip $(subst $(-separator), ,$(firstword $(subst $(-separator)$(firstword $(filter $1,$2))$(-separator), ,$(subst $(space),$(-separator), $2 ))))))

## Return the index of the first occurrence of _word_ if present or the empty list.
## *Indexing starts at 0*, contrary to the make-internal behaviour of numbering lists from 1!
index-of = $(if $(filter $1,$2),$(words $(call up-to,$1,$2)))

## Return the portion of _list_ following the first occurrence of _word_.
## If _word_ is not in _list_, the empty string/list is returned.
up-from = $(strip $(wordlist $(or $(call index-of,$1,$(-never-matching) $(-never-matching) $2),2147483647),2147483647,$2))


PROJECT_ROOT := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))..

ifeq ($(OS),Windows_NT)
	ifeq ($(wildcard $(PROJECT_ROOT)\bin),)
		PYTHON = C:/windows/py.exe
	else
		PYTHON = $(PROJECT_ROOT)/bin/python.exe
	endif

	RM = del
	RMTREE = rd /s /q
	MKDIR = md

	echo = echo.$(1)

	if-exists = if exist $(1) $(2)
	if-not-exists = if not exist $(1) $(2)
	truncate = copy /b nul $(subst /,\,$(1))
	copy = copy $(subst /,\,$(1)) $(subst /,\,$(2))
	link = mklink /H $(2) $(1)
	toupper = $(1)
	touch = copy /b $(subst /,\,$(1)) +,,
	curl = powershell -Command "curl $(1) -o $(2)"
	unzip = powershell -Command "Expand-Archive -Path $(1) -DestinationPath $(2)"

	SHELL = cmd.exe
else
	PYTHON = python3
	
	RM = rm -f
	RMTREE = rm -rf
	MKDIR = mkdir -p

	echo = echo '$(1)'

	if-exists = [ -f $(1) ] && $(2)
	if-not-exists = [ -f $(1) ] || $(2) 
	truncate = truncate -s 0 $(1)
	copy = cp $(1) $(2)
	link = ln -srf $(1) $(2)
	toupper = $(shell echo $(1) | tr '[:lower:]' '[:upper:]')
	touch = touch $(1)
	curl = curl -L $(1) -o $(2)
	unzip = unzip $(1) -d $(2)
endif

defaults::
	@$(call echo,  PYTHON = $(PYTHON))

.DEFAULT_GOAL = all
