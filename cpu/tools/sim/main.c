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

static void print_bin(FILE *f, int value, int n_bits)
{
    int mask = 1 << (n_bits - 1);

    for (int i = 0; i < n_bits; i++) {
        if (value & mask)
            fputc('1', f);
        else
            fputc('0', f);

        mask >>= 1;
    }
}

#define PR(f, x, l, ...)    \
    do {                    \
        fprintf(f, #x " "); \
        print_bin(f, x, l); \
        __VA_ARGS__;        \
    } while (0)

#define S(f, x) fprintf(f, x)

int main(int argc, char **argv)
{
    int opt;

    int dump_freq = -1;
    int stop_after = -1;

    bool wait = true;
    bool stop_at_nop = false;
    bool dump_mem = false;
    bool interactive = true;

    while ((opt = getopt(argc, argv, "hd:k:snMN")) != -1) {
        switch (opt) {
            case 'h':
            case '?':
                fprintf(stderr,
                    "Usage: %s [ -h | [ -d | -k ] N | -s | -n | -M | -N ] BIN\n"
                    "    -h       Shows this help menu\n"
                    "    -d N     Dumps simulation state every N instructions\n"
                    "    -k N     Stops the simulation after N instructions have been "
                    "executed\n"
                    "    -s       Stops the simulation when a `nop` is reached\n"
                    "    -n       Disables waiting on the `wait` instruction\n"
                    "    -M       Dumps memory when exiting\n"
                    "    -N       Non-interactive mode, disables printing of prompts\n"
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
            case 'k': {
                char *end = NULL;
                stop_after = strtoull(optarg, &end, 10);

                if (*end != '\0') {
                    fprintf(stderr, "%s: invalid argument for -k\n", argv[0]);
                    return 1;
                }

                break;
            }
            case 's':
                stop_at_nop = true;
                break;
            case 'n':
                wait = false;
                break;
            case 'M':
                dump_mem = true;
                break;
            case 'N':
                interactive = false;
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

    if (n_read == 256 && fgetc(fp) != EOF) {
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
    uint32_t ic = 0;

    while (true) {
        uint8_t instruction = memory[pc++];

        ir = instruction >> 4;
        rs = instruction & 0xf;

        if ((rs & 0x3) == 0x3)
            regs[REG_I] = memory[pc++];

        switch (ir) {
            case OP_AND:
                regs[REG_R] = regs[rs >> 2] & regs[rs & 0x3];
                zero = !regs[REG_R];

                break;
            case OP_OR:
                regs[REG_R] = regs[rs >> 2] | regs[rs & 0x3];
                zero = !regs[REG_R];

                break;
            case OP_NOT:
                regs[REG_R] = ~regs[rs >> 2];
                zero = !regs[REG_R];

                break;
            case OP_ADD:
                regs[REG_R] = add_with_flags( //
                    regs[rs >> 2], regs[rs & 0x3], 0, &carry, &overflow);

                zero = !regs[REG_R];
                sign = (regs[REG_R] & 0x80) == 0x80;

                break;
            case OP_SUB:
                regs[REG_R] = add_with_flags(
                    regs[rs >> 2], ~regs[rs & 0x3], 1, &carry, &overflow);

                zero = !regs[REG_R];
                sign = (regs[REG_R] & 0x80) == 0x80;

                break;
            case OP_CMP:
                regs[REG_I] = add_with_flags(
                    regs[rs >> 2], ~regs[rs & 0x3], 1, &carry, &overflow);

                zero = !regs[REG_I];
                sign = (regs[REG_I] & 0x80) == 0x80;

                break;
            case OP_JMP:
                pc = regs[rs & 0x3];
                break;
            case OP_JEQ:
                if (zero)
                    pc = regs[rs & 0x3];

                break;
            case OP_JGR:
                if (sign)
                    pc = regs[rs & 0x3];

                break;
            case OP_LOAD:
                regs[rs >> 2] = memory[regs[rs & 0x3]];
                break;
            case OP_STORE:
                memory[regs[rs & 0x3]] = regs[rs >> 2];
                break;
            case OP_MOV:
                regs[rs >> 2] = regs[rs & 0x3];
                break;
            case OP_IN: {
                uint8_t input = 0;
                uint8_t mask = 0x80;

                if (interactive) {
                    fprintf(stdout, " $ ");
                    fflush(stdout);
                }

                while (mask) {
                    char tmp;
                    fscanf(stdin, "%c", &tmp);

                    switch (tmp) {
                        case '1':
                            input |= mask;
                            /* fall through */
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
                if (interactive)
                    fprintf(stdout, " > ");

                print_bin(stdout, regs[rs >> 2], 8);
                S(stdout, "\n");

                break;
            case OP_WAIT:
                if (wait) {
                    interrupt = 0;

                    if (interactive) {
                        fprintf(stdout, " @ ");
                        fflush(stdout);
                    }

                    while (!interrupt)
                        ;

                    interrupt = 0;
                }

                break;
            case OP_NOP: /* */
                break;
        }

        if (dump_freq > 0 && ic % dump_freq == 0) {
            PR(stderr, pc, 8, S(stderr, "\t"));
            PR(stderr, ir, 4, S(stderr, "\t"));
            PR(stderr, rs, 4, S(stderr, "\t"));
            PR(stderr, zero, 1, S(stderr, "\t"));
            PR(stderr, sign, 1, S(stderr, "\t"));
            PR(stderr, carry, 1, S(stderr, "\t"));
            PR(stderr, overflow, 1, S(stderr, "\t"));

            fprintf(stderr, "ic %08x\n", ic);

            for (int i = 0; i < REG_MAX; i++) {
                fprintf(stderr, "%s ", REG_NAMES[i]);
                print_bin(stderr, regs[i], 8);

                S(stderr, "\n");
            }
        }

        ic++;

        if (stop_at_nop && ir == OP_NOP)
            break;

        if (stop_after == ic)
            break;
    }

    if (dump_mem) {
        for (int i = 0; i < 16; i++) {
            for (int j = 0; j < 16; j++) {
                fprintf(stderr, "%02x", memory[16 * i + j]);

                if (j != 15)
                    S(stderr, "  ");
            }

            S(stderr, "\n");
        }
    }
}
