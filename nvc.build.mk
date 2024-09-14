# NOTE: nvc uses VHDL 2008 by default

ifeq ($(OS),Windows_NT)
	PATH := $(PATH):C:/PROGRA~1/NVC/bin
endif

NVC = nvc

NVCFLAGS =
NVCELAB = $(NVCFLAGS) -j
NVCRUN = $(NVCFLAGS) -w

OUT = $(patsubst %.vhdl,work/%.link,$(SRC))

all: work/_index

run: work/_index
	$(NVC) -r $(TOPLEVEL) $(NVCRUN)

clean:
	$(RMTREE) work
	
work/_index: $(OUT)
	$(NVC) -e $(TOPLEVEL) $(NVCELAB) 

# Makes a link called work/link.% (with the file's actual case) that links to 
# work/WORK.% (upper case), that way it works on both Windows and UNIX 
# (reminder: Windows is case-insensitive but case-preserving, while UNIX 
# is case-sensitive, so even though work/WORK.% and work/work.% are the 
# same file on Windows(!), GNU Make treats them as different files).
# 
# Also, symlinks require admin privileges on Windows.
# 
# For hard links to work, we need to create work/WORK.% if it doesn't already exist. 
# We don't care about its previous contents, so we can just truncate it.
#
# Meanwhile, you can't create hard links on Android, so we just make a symlink
# on UNIX and then always touch the link so make sees it as up-to-date.
#
# NOTE: toupper doesn't work on Windows, but Windows 
# is case-insensitive so that's not really an issue (hopefully)
#
# NOTE: nvc may fail and not update the output files, in that case we must
# guarantee the input file is still newer by manually touching it
work/%.link: %.vhdl
	@$(MKDIR) "$(dir $@)"
	
	@$(TRUNCATE) "work/WORK.$(call toupper,$(notdir $*))"
	@$(call link,"work/WORK.$(call toupper,$(notdir $*))","$@")

	@$(call touch,"$?")
	
	$(NVC) -a $?
	
	@$(call touch,"$@")
