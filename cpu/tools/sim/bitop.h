#ifndef BITOP_H
#define BITOP_H

#include <stdint.h>

static uint8_t add_with_flags(uint8_t a, uint8_t b, uint8_t *carry, uint8_t *overflow)
{
    uint8_t c = 0, p = 1;
    uint8_t result;
    uint8_t carry_out, carry_in = 0;

    for (int i = 0; i < 8; i++) {
        result = (a & 1) ^ (b & 1) ^ carry_in;
        carry_out = (a & b & 1) | (a & carry_in) | (b & carry_in);

        a >>= 1;
        b >>= 1;

        if (i == 7) {
            *carry = carry_out;
            *overflow = carry_in ^ carry_out;
        }

        carry_in = carry_out;

        if (result)
            c |= p;

        p <<= 1;
    }

    return c;
}

#endif /* BITOP_H */
