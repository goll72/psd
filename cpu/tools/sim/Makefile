DEFCFLAGS = $(CFLAGS) -std=c99 -pedantic -Wall -Wextra 

ifeq ($(OS),Windows_NT)
all: sim.exe

sim.exe: 
else
all: sim

sim: main.c asm.h bitop.h getopt.h
	$(CC) $(DEFCFLAGS) main.c -o $@

clean:
	rm -f sim
endif
