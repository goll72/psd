SIMROOT ?= .

ifeq ($(OS),Windows_NT)
SIMDEPS = 
else
SIMDEPS = $(SIMROOT)/main.c $(SIMROOT)/asm.h $(SIMROOT)/bitop.h $(SIMROOT)/getopt.h
endif
