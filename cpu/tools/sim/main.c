#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <signal.h>
#include <stdbool.h>

#include "asm.h"
#include "bitop.h"

#include "getopt.h"

static volatile sig_atomic_t interrupt = 0;

static void handle_sigint(int signo)
{
    (void)signo;

    if (interrupt == 1)
        _Exit(0);

    interrupt = 1;
}

static void print_bin(int value, int n_bits)
{
    int mask = 1 << (n_bits - 1);

    for (int i = 0; i < n_bits; i++) {
        if (value & mask)
            putchar('1');
        else
            putchar('0');

        mask >>= 1;
    }
}

#define PR(x, l, ...)    \
    do {                 \
        printf(#x " ");  \
        print_bin(x, l); \
        __VA_ARGS__;     \
    } while (0)

#define S(x) printf(x)

int main(int argc, char **argv)
{
    int opt;

    int dump_freq = -1;

    bool wait = true;
    bool stop_sim = false;

    while ((opt = getopt(argc, argv, "hd:sn")) != -1) {
        switch (opt) {
            case 'h':
            case '?':
                fprintf(stderr,
                    "Usage: %s [ -h | -d N | -s | -n ] BIN\n"
                    "    -h         Shows this help menu\n"
                    "    -d N       Dumps simulation state every N instructions\n"
                    "    -s         Stops the simulation when EOF is reached\n"
                    "    -n         Disables waiting on the `wait` instruction\n"
                    "\n"
                    "    BIN        A binary file containing executable machine code\n",
                    argv[0]);

                return opt == '?';
            case 'd': {
                char *end = NULL;
                dump_freq = strtoull(optarg, &end, 10);

                if (*end != '\0') {
                    fprintf(stderr, "%s: invalid argument for -d\n", argv[0]);
                    return 1;
                }

                break;
            }
            case 's':
                stop_sim = true;
                break;
            case 'n':
                wait = false;
                break;
        }
    }

    if (optind >= argc) {
        fprintf(stderr, "%s: no file has been provided\n", argv[0]);
        return 1;
    }

    char *filename = argv[optind];
    FILE *fp = fopen(filename, "rb");

    if (!fp) {
        fprintf(stderr, "%s: couldn't open file `%s'\n", argv[0], filename);
        return 1;
    }

    uint8_t memory[256] = { 0 };

    size_t n_read = fread(memory, 1, sizeof memory, fp);

    if (n_read > 256) {
        fprintf(stderr, "%s: file `%s' is larger than 256 bytes\n", argv[0], filename);
        return 1;
    }

    if (wait)
        signal(SIGINT, handle_sigint);

    uint8_t pc = 0;

    uint8_t regs[REG_MAX] = { 0 };

    uint8_t ir, rs;
    uint8_t zero = 0, sign = 0, carry = 0, overflow = 0;

    /* Instruction Counter */
    int ic = 0;

    while (true) {
        uint8_t instruction = memory[pc++];

        ir = instruction >> 4;
        rs = instruction & 0xf;

        if ((rs & 0x3) == 0x3)
            regs[REG_I] = memory[pc++];

        switch (ir) {
            case OP_AND:
                regs[REG_R] = regs[rs >> 2] & regs[rs & 0x3];
                break;
            case OP_OR:
                regs[REG_R] = regs[rs >> 2] | regs[rs & 0x3];
                break;
            case OP_NOT:
                regs[REG_R] = ~regs[rs >> 2];
                break;
            case OP_ADD:
                regs[REG_R] = add_with_flags( //
                    regs[rs >> 2], regs[rs & 0x3], &carry, &overflow);
                break;
            case OP_SUB:
                regs[REG_R] = add_with_flags(
                    regs[rs >> 2], ~regs[rs & 0x3] + 1, &carry, &overflow);
                break;
            case OP_CMP:
                regs[REG_I] = add_with_flags(
                    regs[rs >> 2], ~regs[rs & 0x3] + 1, &carry, &overflow);

                if (regs[REG_I] == 0)
                    zero = 1;

                if ((regs[REG_I] & 0x80) == 0x80)
                    sign = 1;

                break;
            case OP_JMP:
                pc = memory[pc];
                break;
            case OP_JEQ:
                if (zero)
                    pc = memory[pc];
                else
                    pc++;

                break;
            case OP_JGR:
                if (sign)
                    pc = memory[pc];
                else
                    pc++;

                break;
            case OP_LOAD:
                regs[REG_I] = memory[pc++];
                regs[rs >> 2] = memory[regs[REG_I]];
                break;
            case OP_STORE:
                regs[REG_I] = memory[pc++];
                memory[regs[REG_I]] = regs[rs >> 2];
                break;
            case OP_MOV:
                regs[rs >> 2] = regs[rs & 0x3];
                break;
            case OP_IN: {
                uint8_t input = 0;
                uint8_t mask = 0x80;

                printf(" $ ");
                fflush(stdout);

                while (mask) {
                    char tmp;
                    scanf("%c", &tmp);

                    switch (tmp) {
                        case '1':
                            input |= mask;
                        case '0':
                            mask >>= 1;
                        default:
                            break;
                    }
                }

                regs[rs >> 2] = input;

                break;
            }
            case OP_OUT:
                print_bin(regs[rs >> 2], 8);
                printf("\n");

                break;
            case OP_WAIT:
                if (wait) {
                    interrupt = 0;

                    printf(" @ ");
                    fflush(stdout);

                    while (!interrupt)
                        ;

                    interrupt = 0;
                }

                break;
            case OP_NOP: /* */
                break;
        }

        if (dump_freq > 0 && ic % dump_freq == 0) {
            PR(pc, 8, S("\t"));
            PR(ir, 4, S("\t"));
            PR(rs, 4, S("\t"));
            PR(zero, 1, S("\t"));
            PR(sign, 1, S("\t"));
            PR(carry, 1, S("\t"));
            PR(overflow, 1, S("\n"));

            for (int i = 0; i < REG_MAX; i++) {
                printf("%s ", REG_NAMES[i]);
                print_bin(regs[i], 8);

                S("\n");
            }
        }

        ic++;

        if (stop_sim && pc == (n_read % 256))
            break;
    }
}