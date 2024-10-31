#ifndef ASM_H
#define ASM_H

#define OP_AND   0x0
#define OP_OR    0x1
#define OP_NOT   0x2
#define OP_ADD   0x3
#define OP_SUB   0x4
#define OP_CMP   0x5
#define OP_JMP   0x6
#define OP_JEQ   0x7
#define OP_JGR   0x8
#define OP_LOAD  0x9
#define OP_STORE 0xa
#define OP_MOV   0xb
#define OP_IN    0xc
#define OP_OUT   0xd
#define OP_WAIT  0xe
#define OP_NOP   0xf

#define REG_A    0x0
#define REG_B    0x1
#define REG_R    0x2
#define REG_I    0x3

#define REG_MAX  0x4

static const char *REG_NAMES[REG_MAX] = {
    "a ", "b ", "r ", "i "
};

#endif /* ASM_H */
