#!/usr/bin/env python3


import argparse

from asm import *
from util import FORMATS


def main():
    parser = argparse.ArgumentParser(prog="objdump", description="dump machine code in textual, human-readable form")

    parser.add_argument("input", metavar="FILE", type=argparse.FileType("rb"), help="input file")
    parser.add_argument("-f", "--format", choices=list(FORMATS), metavar="FORMAT")
    parser.add_argument("-s", "--spaces", type=int, metavar="N", help="add N blank lines after every line", default=0)

    args = parser.parse_args()

    if args.format is None and args.input.name.split(".")[-1] in FORMATS:
        args.format = args.input.name.split(".")[-1]

    if args.format is None:
        raise argparse.ArgumentError(args.format, "no format supplied, couldn't determine format from extension")

    code = FORMATS[args.format].deserialize(args.input.read())

    INAMES = { v: k for k, v in INSTRUCTIONS.items() }
    # NOTE: 0x3 == REG_I
    RNAMES = { v: k for k, v in REGS.items() } | { 0x3: "i" }

    pc = 0

    while pc < len(code):
        ir = code[pc] & 0b11110000
        rs = code[pc] & 0b1111

        print(f"  0x{pc:02x}/{pc:08b}   {code[pc]:02x} ", end="")
        
        pc += 1

        instruction = INAMES[ir]

        if (rs & 0b11) == 0b11:
            print(f"{code[pc]:02x}   ", end="")
            ops = RNAMES[rs >> 2], hex(code[pc]) 

            pc += 1
        else:
            print(5 * " ", end="")
            ops = RNAMES[rs >> 2], RNAMES[rs & 0b11]

        match instruction:
            # Zero operands
            case "wait" | "nop":
                print(instruction)

            # One operand
            case "not" | "in" | "out":
                print(f"{instruction} {ops[0]}")

            # One operand, but takes immediate
            case "jmp" | "jeq" | "jgr":
                print(f"{instruction} {ops[1]}")
                
            # Two operands
            case "and" | "or" | "add" | "sub" | "cmp" | "load" | "store" | "mov":
                print(f"{instruction} {ops[0]}, {ops[1]}")

        print("\n" * args.spaces, end="")

if __name__ == "__main__":
    main()
