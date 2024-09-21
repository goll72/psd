part4
=====

A tarefa foi implementar um circuito no qual pudéssemos ver a diferença entre um latch D, 
um flip-flop de borda de subida, e um flip-flop de borda de descida.

O latch tipo D foi implementado no [segundo exercicio](../d_latch) (Parte II).

O flip-flop de borda de subida, que tem como saída o $Q_b$, é acionado somente na borda 
de subida do clock, logo, seu estado só pode ser mudado quando o clock mudar de $0$ para $1$.

 D |    CLK       | $Q_b(t+1)$
---|--------------|------------
 x |      x       |  $Q_b(t)$
 0 |  $\uparrow$  |      0
 1 |  $\uparrow$  |      1

Já o flip-flop de borda de descida, que tem como saída o $Q_c$, é acionado somente na borda 
de descida do clock, logo, seu estado só pode ser mudado quando o clock mudar de $0$ para $1$:

 D |    Clk       | $Q_c(t+1)$
---|--------------|------------
 x |      x       |  $Q_c(t)$
 0 | $\downarrow$ |      0
 1 | $\downarrow$ |      1

