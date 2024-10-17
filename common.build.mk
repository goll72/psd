ifeq ($(ENV),)
$(error Defina ENV para um de: ghdl, modelsim, nvc, quartus)
endif


# Taken from gmtt - GNU Make Table Toolkit (https://github.com/markpiffer/gmtt)
#
# Copyright (c) 2017-2024 Mark Piffer
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


ifeq ($(OS),Windows_NT)
	PYTHON = C:\windows\py.exe

	RM = del
	RMTREE = rd /s /q
	MKDIR = md
	TRUNCATE = copy /b nul 
	copy = copy $(subst /,\,$(1)) $(subst /,\,$(2))
	link = mklink /H $(2) $(1)
	toupper = $(1)
	touch = copy /b $(1) +,,
	curl = bitsadmin /transfer psd-stuff /download /priority normal $(1) $(2)
	unzip = powershell -Command "Expand-Archive -Path $(1) -DestinationPath $(2)"

	SHELL = cmd.exe
else
	PYTHON = python3
	
	RM = rm -f
	RMTREE = rm -rf
	MKDIR = mkdir -p
	TRUNCATE = truncate -s 0
	copy = cp $(1) $(2)
	link = ln -srf $(1) $(2)
	toupper = $(shell echo $(1) | tr '[:lower:]' '[:upper:]')
	touch = touch $(1)
	curl = curl -L $(1) -o $(2)
	unzip = unzip $(1) -d $(2)
endif
