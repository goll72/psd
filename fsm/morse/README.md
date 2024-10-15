morse
=====

O objetivo desse exercício é reimplementar 
[o circuito desenvolvido anteriormente](../../morse) para codificar uma letra
em código morse, usando Máquina de Estados (FSM). Escolhemos usar uma Máquina de
Estados de Moore, cuja representação gráfica é exibida a seguir.

```mermaid
graph LR;
  R[Reset];
  A((A / q = 0, n = 0));
  B((B / q = 0, n = 0));
  C((C / q = 1, n = 0));
  D((D / q = 1, n = 0));
  E((E / q = 1, n = 0));
  F((F / q = 1, n = 1));
                             
  R-->A;
                                  
  A-->|enable = 0|B;
  B-->|c = 0|A;
  B-->|w = 0|C;
  C-->B;
  B-->|w = 1|D;
  D-->E;
  E-->F;
  F-->B;
```

O estado $ A $ é o estado inicial, onde devemos aguardar até que o
usuário pressione o botão $ \textrm{enable} $. O estado $ B $ é um
estado de pausa entre cada pulso do código morse, que retornará ao
estado inicial caso a contagem da quantidade restante de pulsos que
devem ser exibidos chegue a zero. As saídas da FSM são $ q $ (o 
código em si) e $ n $ (sinal para decrementar o contador do tamanho da
sequência restante e habilitar o registrador de deslocamento que guarda
a sequência de pulsos do código morse por um ciclo de clock).
