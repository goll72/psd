display-word
============

A parte IV consiste em implementar um circuito que rotacione, da direita para a esquerda,
em intervalos de aproximadamente um segundo, uma palavra exibida em um conjunto de 4 
displays de sete segmentos. 

A palavra correspondente à placa FPGA adotada é: " dE0".

Utilizando o contador implementado na [parte III](../flash), criamos um delay para habilitar
um conjunto de registradores de deslocamento, onde cada registrador de deslocamento corresponde
a um dos seis segmentos de cada display, e cada registrador de deslocamento contém aquele dado
segmento de todos os displays. Percebe-se um deslocamento realizado em um dado registrador 
corresponde a uma rotação no segmento correspondente. Habilitando todos os registradores de 
deslocamento ao mesmo tempo, temos a rotação de uma palavra por uma unidade, como desejado.

*Obs. os registradores de deslocamento usados têm load assíncrono, para permitir que o
circuito seja "resetado" para um estado inicial ao habilitar esse sinal, usando apenas um sinal.*
