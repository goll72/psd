# SR Latch
  O circuito Latch SR é um circuito simples capaz de armazenar um bit de memória, é formado por duas portas lógicas NOR, conectando a saída de uma com a entrada da outra.

  ![1692895856717](https://github.com/user-attachments/assets/5b896453-8b0c-49f9-9822-bfb3b568fa03)

  
## Estrutura
  A entrada é composta pelas entradas S(set), R(reset) e um sistema de controle(clock), sendo a primeira responsável por definir o valor que irá ser armazenado, enquanto a entrada R é responsável por resetar 
o Latch, a saída de primeira porta NOR é conectada a entrada da segunda e vice-versa.

## Funcionamento
  O funcionamento do SR Latch é simples, no caso de S(1) e R(0), as saidas serão Q(1) e !Q(0), pois o valor armazenado foi 1, e se a entrada for o oposto, a saída também será oposta, além disso,
a entrada S(1) e R(1) é uma condição proibida, o que gera uma saída indefinida.

# Gated D latch
  Assim como a Latch SR, o Gated D latch também é um circuito feito para armazenar memória sendo esse uma variação do primeiro, a diferença é que ele evita a condição proibida do Latch SR 
(onde as duas entradas são ativadas ao mesmo tempo), o circuito Gated D latch utiliza apenas uma entrada(D), além do sistema de controle(clock), sendo essa o valor a ser armazenado.

![gated-D-latch](https://github.com/user-attachments/assets/8b8372eb-cf12-4da9-b43e-ac247b89bd6b)


## Estrutura
  Como dito antes, há uma única entrada (D), que representa o valor a ser armazenado e o sistema de controle que determina se o valor será armazenado ou não. As saídas são chamadas de Q e !Q que representam
respectivamente o valor a ser armazenado e o inverso do mesmo. O circuito é composto por 4 portas NAND, sendo bem similar ao Latch SR.

## Funcionamento
  O Gated D latch é mais simples de ser utilizado quando comparado ao SR Latch, pois possui apenas 1 entrada, funcionando da seguinte maneira, quando o sistema de controle está liberado, o valor armazenado é D,
caso não esteja liberado, o valor não é armazenado.
