#!/usr/bin/env python3


import re
import sys

import argparse
from itertools import chain, combinations

from typing import Iterable

from asm import *
from util import FORMATS


def print_message(filename: str, line_number: int, line: str, message: str, span: tuple[int, int] | None = None):
    print(f"{filename}:{line_number + 1}: {message}", file=sys.stderr)
    
    if line:
        print(f" | {line.strip('\n')}")

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
    
    pattern = re.compile(r"^(?:([a-zA-Z_][a-zA-Z0-9_]*):)?(?:\s*(\w+)(?:\s+(\w+)(?:,\s*(\w+|\d+))?)?)?(?:;.*)?$")
    
    for line_number, line in enumerate(args.input):
        # XXX: can we assume case-insensitive code?
        line = line.lower()

        matches = re.search(pattern, line)

        if matches is None:
            print_message(in_file, line_number, line, "Syntax error", (0, len(line) - 1))
            sys.exit(2)

        label, instr, a, b = matches.groups()

        if label is not None:
            if label in resolved_labels:
                print_message(in_file, line_number, line, f"Warning: label {label} has already been used", matches.span(1))

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
                print_message(in_file, line_number, line, "Error: extraneous operand(s) for instruction that takes no operands", (matches.span(3)[0], matches.span(4)[1]))
                sys.exit(2)

            # Two operands
            case "and" | "or" | "add" | "sub" | "cmp" | "load" | "store" | "mov", a, None:
                print_message(in_file, line_number, line, "Error: missing operand for instruction that takes two operands", (len(line) - 1, len(line)))
                sys.exit(2)

            case "and" | "or" | "add" | "sub" | "cmp" | "load" | "store" | "mov", a, b:
                op = INSTRUCTIONS[instr] | (REGS[a] << 2)

                if b in REGS:
                    op = op | REGS[b]

                    code.append(op)
                else:
                    op = op | 0b11

                    code.append(op)
                    # XXX: this might have to be changed later
                    code.append(int(b, base=0))

            # One operand
            case "not" | "jmp" | "jeq" | "jgr" | "in" | "out", a, None:
                if instr in ("jmp", "jeq", "jgr"):
                    code.append(INSTRUCTIONS[instr])
                    code.append(a)
                    
                    used_labels.append(a)
                else:
                    code.append(INSTRUCTIONS[instr] | (REGS[a] << 2))
              
            case "not" | "jmp" | "jeq" | "jgr" | "in" | "out", a, b:
                print_message(in_file, line_number, line, "Error: extraneous operand for instruction that takes one operand", matches.span(4))
                sys.exit(2)
                
            case _:
                print_message(in_file, line_number, line, f"Error: Invalid instruction {instr}", matches.span(1))
                sys.exit(2)

    for label in used_labels:
        if label not in resolved_labels:
            print_message(in_file, -1, "", f"Jump target {label} has not been defined")
            sys.exit(2)

    for index, value in enumerate(code):
        if type(value) == str:
            code[index] = resolved_labels[value]

    for format in args.format:
        output = f"{args.input.name[:-2]}.{format}"
        
        with open(output, "wb") as f:
            f.write(FORMATS[format].serialize(code))

if __name__ == "__main__":
    main()
