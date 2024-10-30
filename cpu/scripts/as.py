#!/usr/bin/env python3

import re
import sys

INSTRUCTIONS = {
    "and": 0x00,
    "or": 0x10,
    "not": 0x20,
    "add": 0x30,
    "sub": 0x40,
    "cmp": 0x50,
    "jmp": 0x60,
    "jeq": 0x70,
    "jgr": 0x80,
    "load": 0x90,
    "store": 0xa0,
    "mov": 0xb0,
    "in": 0xc0,
    "out": 0xd0,
    "wait": 0xe0,
    "nop": 0xf0
}

REGS = {
    "a": 0x0,
    "b": 0x1,
    "r": 0x2
}

def print_message(filename: str, line_number: int, line: str, message: str, span: tuple[int, int] | None = None):
    print(f"{filename}:{line_number + 1}: {message}", file=sys.stderr)
    
    if line:
        print(f" | {line.strip("\n")}")

    if span is not None:
        start, end = span
        end = (len(line) + end) % len(line)
        
        print(f"   {' ' * start}{'^' * (end - start)}")
        
def main():
    if len(sys.argv) != 2 or sys.argv[1] in ('-h', '--help'):
        print("Usage: as.py file.s", file=sys.stderr)
        sys.exit(1)
    
    in_file = sys.argv[1]

    if not in_file.endswith(".s"):
        print("Invalid filename", file=sys.stderr)
        sys.exit(1)

    out_file = in_file.removesuffix(".s") + ".bin"

    resolved_labels = {}
    used_labels = []

    code = []
    
    pattern = re.compile(r"^(?:([a-zA-Z_][a-zA-Z0-9_]*):)?(?:\s*(\w+)(?:\s+(\w+)(?:,\s*(\w+|\d+))?)?)?(?:;.*)?$")
    
    with open(in_file) as f:
        for line_number, line in enumerate(f):
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
                case "wait" | "nop", None, None:
                    code.append(INSTRUCTIONS[instr])

                case "wait" | "nop", a, b:
                    print_message(in_file, line_number, line, "Error: extraneous operand(s) for instruction that takes no operands", (matches.span(3)[0], matches.span(4)[1]))
                    sys.exit(2)
                
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

    with open(out_file, "wb") as f:
        f.write(bytes(code))

if __name__ == "__main__":
    main()
