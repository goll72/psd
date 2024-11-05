ENV=_

include ../../../mk/common.build.mk

DEFCFLAGS = $(CFLAGS) -std=c99 -pedantic -Wall -Wextra 

ifeq ($(OS),Windows_NT)
OUT = sim.exe
else
OUT = sim
endif

all: $(OUT)

include ./defs.mk

ifeq ($(OS),Windows_NT)
sim.exe:
	$(call curl,https://github.com/goll72/psd/releases/download/sim/sim.exe,$(SIMROOT)/sim.exe)
else
$(OUT): $(SIMDEPS)
	$(CC) $(DEFCFLAGS) main.c -o $@
endif

clean:
	rm -f $(OUT)

build-windows:
	$(MAKE) all CC=x86_64-w64-mingw32-gcc OUT=sim.exe
	gh release create sim --notes "Simulador da CPU/ISA para Windows" sim.exe || \
	gh release upload --clobber sim sim.exe
