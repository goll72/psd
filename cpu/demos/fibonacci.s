; mem[0xff] vai guardar o endereço da posição atual na sequência

; um comando str/data cairia bem aqui...
mov r, 0xfe
store r, 0xff

mov r, 0
store r, 0xfe
mov r, 1
store r, 0xfd

fib_loop:
        load r, 0xff

        load a, r
        sub  r, 1
        load b, r
        sub  r, 1
        add  a, b
        mov  a, r

        load r, 0xff
        sub  r, 2

        store a, r

        add  r, 1
        store r, 0xff

        cmp r, 0xf4
        jeq end
        jmp fib_loop
end:
        mov r, 0xfe
print_loop:
        load a, r
        out a
        wait
        sub r, 1
        cmp r, 0xf4
        jeq halt
        jmp print_loop
halt:
        wait
