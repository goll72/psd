wait
## Saída: 0 se for composto, 1 se for primo
in a

cmp a, 2
jeq end_prime

cmp a, 3
jeq end_prime

and a, 1
## A instrução acima já fará o equivalente disso:
# mov r, 0
jeq end_composite

## Novamente, temos um "mov r, 0" implícito
sub a, 1
jeq end_composite

## Guarda o valor de r no endereço de memória 0xff
store a, 0xff
mov b, 3

prime_check_loop:
        ## Restaura r para verificarmos se r é divisível por b
        ## b vai variar de 3 a n - 1
        load r, 0xff

divide_sub_loop:
        sub r, b

        ## Se o resultado for 0, r é divisível por b, logo é composto
        jeq end_composite
        ## Se for negativo, r não é divisível por b e devemos sair do loop
        jgr end_divide_sub_loop
        ## Devemos continuar no loop
        jmp divide_sub_loop
end_divide_sub_loop:
        add b, 1
        mov b, r

        load r, 0xff

        ## Chegamos a n - 1 (acabamos de incrementar b)
        cmp b, r

        jeq end_prime
        jmp prime_check_loop

end_prime:
        mov r, 1

end_composite:
        out r
        wait

        nop
