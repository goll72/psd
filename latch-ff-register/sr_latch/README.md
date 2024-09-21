sr-latch
========

O circuito Latch SR é um circuito simples capaz de armazenar um bit de memória, 
é formado por duas portas lógicas NOR (ou NAND), conectando a saída de uma com a entrada da outra.

![1692895856717](https://github.com/user-attachments/assets/5b896453-8b0c-49f9-9822-bfb3b568fa03)
  
## Estrutura

A entrada é composta pelos sinais $S$ (set), $R$ (reset) e clock. Quando habilitado, o sinal $S$
faz o latch armazenar nível lógico $1$, enquanto o $R$ faz o latch armazenar nível lógico $0$.
No Latch, a saída da primeira porta NOR é conectada à entrada da segunda e vice-versa.

## Funcionamento

O funcionamento do Latch SR é simples, no caso $S = 1$ e $R = 0$, as saidas serão $Q = 1$ e 
$\overline{Q} = 0$ (o valor armazenado é $1$); invertendo os sinais de entrada, a saída também será
invertida. O caso $S = 1$ e $R = 1$ deve ser evitado, pois leva o circuito a um estado indefinido.

# Latch D

Assim como a Latch SR, o latch D também é um circuito feito para armazenar informação (um bit),
sendo esse uma variação do primeiro que impede as duas entradas de serem habilitadas ao mesmo tempo.
Usa apenas uma entrada ($D$), além do clock, sendo essa entrada o valor a ser armazenado.

![gated-D-latch](https://github.com/user-attachments/assets/8b8372eb-cf12-4da9-b43e-ac247b89bd6b)

Quando o latch possui um sinal de clock, esse sinal impede que qualquer valor de entrada seja armazenado
enquanto tiver nível lógico $0$, por isso denominamos esse tipo de latch "gated". De outra forma,
podemos dizer que esse tipo de latch depende do clock e opera por nível (nível lógico $1$).
