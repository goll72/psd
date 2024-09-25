morse
=====

Nesse projeto, o objetivo é exibir uma letra entre A e H em código morse,
sendo cada letra representada por uma sequência de 3 bits. A saída consiste
de um LED, que acenderá por um determinado intervalo de tempo, correspondendo
a pulsos longos (1.5 segundos) ou curtos (0.5 segundos).

## Exibição de cada letra

A • — <br/>
B — • • • <br/>
C — • — • <br/>
D — • • <br/>
E • <br/>
F • • — • <br/>
G — — • <br/>
H • • • • <br/> 
<br/>

Pontos representam pulsos curtos e linhas pulsos longos.

## Funcionamento

Ao receber o vetor de entrada, o circuito identifica a letra (a letra A é representada por "000", B por "001" e assim por diante) e o código relacionado a ela, e gera outro vetor com o código em morse, 
impulsos curtos são representados por "1", e longos por "111", já que sua duração corresponde ao triplo da duração do curto), o LED desligado é representado por "0". Dessa forma, o código de A, por exemplo, seria representado por "10111", 
pois o LED liga por 0.5 segundos, desliga, e depois liga por 1.5 segundos.

O circuito utiliza um registrador de deslocamento para deslocar essa sequência e exibir o bit atual, e usa um contador para contar o número de 
deslocamentos.

### Contador

O contador registrador foi implementado utilizando o tipo unsigned do VHDL, o qual suporta operações aritméticas, dessa forma toda vez que o clock estiver em subida,
o contador será incrementado em 1.

### Registrador de deslocamento

O registrador de deslocamento (*shift register*) foi implementado utilizando um inteiro N genérico como entrada e um vetor de tamanho N, dessa forma, em toda subida do clock, o vetor é "shiftado" para
a esquerda utilizando um signal auxiliar, ou seja, o bit armazenado na posição mais a esquerda vai para o começo, enquanto o resto se move nessa direção.
