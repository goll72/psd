in a
store a, 0xff
in b
store 0, 0xfe ; 2º valor da multiplicação

loop_start:
        cmp a, 0
        jeq loop_end
        load r, 0xfe
        add r, a
        store r, 0xfe
        sub a, 1       ; r <- a - 1
        mov a, r       ; a <- r
        jmp loop_start
loop_end:
        load r, 0xfe
        out r
