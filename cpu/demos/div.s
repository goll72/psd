wait
in a
wait
in b

store r, 0xff

mov r, a

div_loop:
        sub r, b
        mov a, r
        load r, 0xff
        add r, 1
        store r, 0xff
        mov r, a
        cmp r, b
        jgr div_end
        jmp div_loop
div_end:
        load r, 0xff
        out r
        wait

        nop    
