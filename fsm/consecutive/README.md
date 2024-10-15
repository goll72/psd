consecutive
===========

Nesse exercício, foi implementada uma máquina de estados para detectar
uma sequência consecutiva de quatro uns ou quatro zeros. A Máquina de Estados
implementada, uma máquina de Moore, consiste de 9 estados, onde um estado é o 
inicial e os demais detectam se o valor atual de $ w $ é consistente com relação
à sequência que estão detectando (quatro estados para verificar uma sequência
consecutiva de quatro zeros e quatro estados para verificar uma sequência consecutiva
de quatro uns). Caso o(s) valor(es) anterior(es) de w seja(m) zero e o atual seja um,
o próximo estado será o estado inicial para detectar uma sequência de uns e vice-versa.

Os estados finais correspondentes a uma sequência de zeros ou uns habilita uma saída,
nesse caso, a porta `LEDR9`. Nota-se que a FSM permanecerá em um estado final se o valor
de w for preservado, ou seja, a FSM detecta todas as sequências consecutivas de quatro uns 
ou quatro zeros, até mesmo sequências que se sobreponham.

Usando os códigos de estado dados, montamos a máquina de estados usando a estrutura 
`case ... when` do VHDL.
