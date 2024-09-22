counter-reg
===========

Foi implementado um contador usando o tipo `unsigned` do VHDL,
que suporta operações aritméticas, permitindo assim simplesmente 
incrementá-lo na borda de subida do clock.

## Quantidade de elementos lógicos usados

O contador de 16 bits usa 32 elementos lógicos ao todo: 16 elementos 
para armazenar o valor da contagem (conjunto de flip-flops, formando
um registrador) e 16 elementos para implementar um somador ripple 
carry de 16 bits.
