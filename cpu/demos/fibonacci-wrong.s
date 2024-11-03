mov a, 0
mov b, 1
mov r, 0x10

store a, r
add r, 1

store b, r

mov r, 0x12

loop_start:
        add a, b
        store r, r

        mov a, b
        mov b, r
        add r, 1

        cmp r, 0x1a
        jgr loop_start

loop_end:
        mov r, 0x10

display:
        load a, r
        out a
        add r, 1
        cmp r, 0x1a
        jgr display

        wait
