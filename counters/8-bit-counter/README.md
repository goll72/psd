# 8-bit-counter
=============
## Estrutura do contador de 8bits
O contador de 8 bits foi feito utilizando 8 flip-flops do tipo T, dessa forma podemos contar a quantidade total de elementos lógicos (LEs) utilizados para implementar o circuito:
Quantidade de LEs em um latch D: 10 LEs.
Cada flip-flop_T usa 1 latch D e mais 2 LEs, portanto a quantidade total por flip-flop é: 12 LEs.
O contador de 8bits utiliza 8 flip-flops e mais 7 portas lógicas, portanto a quantidade de LEs é: (8 X 12) + 7 = 103 LEs.
## Diferenças entre a visualização do Quartus e da imagem do exercício:
### Imagem do exercício
![Captura de Tela (7)](https://github.com/user-attachments/assets/8c9d1a03-10fa-4c4e-851b-b685676b58fb)
### Visualizador do Quartus
![contador_4bits](https://github.com/user-attachments/assets/607ae153-d575-4d4d-a8a1-1a5e968b4e3d)
Apesar de a posição dos elementos ser diferente, com uma imagem mostrando os flip-flops na horizontal e outro na vertical, pode-se notar que na prática os dois circuitos são iguais, sendo a única diferença a porta NOT na entrada clear nos flips-flops.
