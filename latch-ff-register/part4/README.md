Part IV - Latch D, e FFs

A tarefa foi implementar um circuito no qual pudemos ver a diferença da simulação entre um Latch D, um Flip Flop de borda de subida, e um Flip Flop borda de descida
O Latch do tipo D foi implementado no segundo exercicio (Part II) sua explicação esta presente em seu README.

O Flip Flop borda de subida, que tem como saída o Q_b, ele é acionado somente na borda de subida do clock, logo, seu estado só pode ser mudado quando
o clock mudar de 0 para 1

D |    Clk       |     Qb
x |      X       |    mantém
0 |   Subida     |      0
1 |   Subida     |      1

O Flip Flop borda de descida, que tem como saída o Q_c, ele é acionado somente na borda de descida do clock, logo, seu estado só pode ser mudado quando
o clock mudar de 0 para 1

D |    Clk       |     Qc
x |      X       |    mantém
0 |   Descida    |      0
1 |   Descida    |      1

