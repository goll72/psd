#!/usr/bin/env python3


import re
import sys

import argparse
from itertools import chain, combinations

from typing import Iterable

from asm import *
from util import FORMATS


MEM_DEFAULT = 0x0


def print_message(filename: str, line_number: int, line: str, message: str, span: tuple[int, int] | None = None):
    print(f"{filename}:{line_number + 1}: {message}", file=sys.stderr)

    newline = "\n"
    
    if line:
        print(f" | {line.strip(newline)}")

    if span is not None:
        start, end = span
        end = (len(line) + end) % len(line)
        
        print(f"   {' ' * start}{'^' * (end - start)}")

def parts(x: Iterable):
    s = list(x)
    return list(map(set, chain.from_iterable(combinations(s, r) for r in range(1, len(s) + 1))))

class AssemblyFileType(argparse.FileType):
    def __call__(self, arg: str):
        if not arg.endswith(".s"):
            raise argparse.ArgumentTypeError("invalid filename, must end in .s")
        
        return super().__call__(arg)

        
def main():
    parser = argparse.ArgumentParser(prog="as", description="assembles a .s assembly file into machine code")

    parser.add_argument("input", metavar="FILE", type=AssemblyFileType("r"), help="assembly file")
    parser.add_argument("-f", "--format", 
                        choices=parts(FORMATS),
                        default={ "bin" },
                        type=lambda x: { s for s in x.split(":") }, 
                        metavar="FORMAT", 
                        help="output file format(s), ':'-separated list")

    args = parser.parse_args()

    resolved_labels = {}
    used_labels = []

    code = []
    data = {}
    
    pattern = re.compile(r"^\s*(?:([a-zA-Z_][a-zA-Z0-9_]*):)?(?:\s*(\w+)(?:\s+(\w+)(?:,\s*(\w+|\d+))?)?)?(?:\s*(?:;|#).*)?\s*$")
    
    for line_number, line in enumerate(args.input):
        line = line.lower()

        matches = re.search(pattern, line)

        if matches is None:
            print_message(args.input.name, line_number, line, "syntax error", (0, len(line) - 1))
            sys.exit(2)

        label, instr, a, b = matches.groups()

        if label is not None:
            if label in resolved_labels:
                print_message(args.input.name, line_number, line, f"warning: label {label} has already been used", matches.span(1))

            # NOTE: len(code) == pc
            resolved_labels[label] = len(code)

        if instr is None:
            continue

        # XXX: handle the cases where a, b are not in REGS? 
        match instr, a, b:
            # Zero operands
            case "wait" | "nop", None, None:
                code.append(INSTRUCTIONS[instr])

            case "wait" | "nop", a, b:
                print_message(args.input.name, line_number, line, "error: extraneous operand(s) for instruction that takes no operands", (matches.span(3)[0], matches.span(4)[1]))
                sys.exit(2)

            # Two operands
            case "and" | "or" | "add" | "sub" | "cmp" | "load" | "store" | "mov", a, None:
                print_message(args.input.name, line_number, line, "error: missing operand for instruction that takes two operands", (len(line) - 1, len(line)))
                sys.exit(2)

            case "and" | "or" | "add" | "sub" | "cmp" | "load" | "store" | "mov", a, b:
                if a not in REGS:
                    print_message(args.input.name, line_number, line, "error: expected register name", matches.span(3))
                    sys.exit(2)

                op = INSTRUCTIONS[instr] | (REGS[a] << 2)

                if b in REGS:
                    op = op | REGS[b]

                    code.append(op)
                else:
                    # NOTE: 0b11 == REG_I
                    op = op | 0b11

                    code.append(op)

                    try:
                        code.append(int(b, base=0))
                    except:
                        print_message(args.input.name, line_number, line, "error: expected integer literal or register name", matches.span(4))
                        sys.exit(2)

            # One operand
            case "not" | "jmp" | "jeq" | "jgr" | "in" | "out", a, None:
                if instr in ("jmp", "jeq", "jgr"):
                    code.append(INSTRUCTIONS[instr] | 0b11)
                    code.append(a)
                    
                    used_labels.append(a)
                else:
                    try:
                        code.append(INSTRUCTIONS[instr] | (REGS[a] << 2))
                    except:
                        print_message(args.input.name, line_number, line, "error: expected register name", matches.span(3))
                        sys.exit(2)
              
            case "not" | "jmp" | "jeq" | "jgr" | "in" | "out", a, b:
                print_message(args.input.name, line_number, line, "error: extraneous operand for instruction that takes one operand", matches.span(4))
                sys.exit(2)

            # NOTE: `byte` isn't an instruction but the same syntax for instructions is used
            case "byte", a, b:
                try:
                    address = int(a, base=0)
                    value = int(b, base=0)

                    data[address] = value
                except:
                    print_message(args.input.name, line_number, line, "error: invalid argument(s) for byte: expected address and value as integer literals")
                    sys.exit(2)

            case _:
                print_message(args.input.name, line_number, line, f"error: invalid instruction {instr}", matches.span(1))
                sys.exit(2)

    for label in used_labels:
        if label not in resolved_labels:
            print_message(args.input.name, -1, "", f"error: jump target {label} has not been defined")
            sys.exit(2)

    for index, value in enumerate(code):
        if type(value) == str:
            code[index] = resolved_labels[value]

    # Adds stuff from the "data section", if there is any
    if data:
        orig_code_len = len(code)
        code.extend([MEM_DEFAULT] * (256 - len(code)))

        for address, value in data.items():
            if address < orig_code_len:
                print_message(args.input.name, -1, "", f"warning: overwriting code with data at address 0x{address:x}")
                print_message(args.input.name, -1, "", f"note: code extends up to address 0x{orig_code_len - 1:x}")
            
            code[address] = value

    for format in args.format:
        output = f"{args.input.name[:-2]}.{format}"
        
        with open(output, "wb") as f:
            f.write(FORMATS[format].serialize(code))

if __name__ == "__main__":
    main()
