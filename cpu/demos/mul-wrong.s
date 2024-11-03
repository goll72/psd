in a
in b

mov r, 0

loop_start:
        cmp b, 0
        jeq loop_end
        add r, a
        sub b, 1
        jmp loop_start
loop_end:
        out r
        wait       
