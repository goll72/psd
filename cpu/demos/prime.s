## Saída: 0 se for composto, 1 se for primo
wait
in a

cmp a, 2
jeq end_prime

cmp a, 3
jeq end_prime

and a, 1
# A instrução acima já fará o equivalente a "mov r, 0"
jeq end_composite

# Novamente, temos um "mov r, 0" implícito
sub a, 1
jeq end_composite

# Vamos verificar realizando divisões a partir do 3
mov b, 3

prime_check_loop:
        # Restaura r para verificarmos se r é divisível por b
        # b vai variar de 3 a n - 2
        mov r, a

        # Se o número de entrada n for tratado como negativo em complemento
        # de dois (MSB igual a 1), devemos subtrair b sucessivamente até
        # que o MSB deixe de ser 1 para que possamos aplicar o algoritmo
        cmp r, 0

        jgr sub_mod_loop
        jmp divide_sub_loop

sub_mod_loop:
        sub r, b

        # Se o resultado for 0, r é divisível por b, logo é composto
        jeq end_composite
        # O resultado ainda é negativo quando interpretado em
        # complemento de dois, devemos continuar subtraindo
        jgr sub_mod_loop

divide_sub_loop:
        sub r, b

        # Se o resultado for 0, r é divisível por b, logo é composto
        jeq end_composite
        # Se for negativo, r não é divisível por b e devemos sair do loop
        jgr end_divide_sub_loop
        # Devemos continuar no loop
        jmp divide_sub_loop
end_divide_sub_loop:
        add b, 2
        mov b, r

        # Já verificamos se n é divisível por n - 2 (acabamos de incrementar b)
        cmp b, a

        jeq end_prime
        jmp prime_check_loop

end_prime:
        mov r, 1

end_composite:
        out r
        wait

        nop
