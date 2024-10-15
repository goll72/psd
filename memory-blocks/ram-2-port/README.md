ram-2-port
==========

Utilizamos a mesma lógica anterior. Agora tendo como objetivo abilitar tanto a escrita do dado em um endereço de memória
como visualização do conteudo da memória de outro endereço. Implementos o exercicio da seguinte maneira:
Um contador que passa por todos os endereços de memória, sendo mostrados tais endereços no (HEX3-2), e seu respectivo conteudo no dispaly (HEX0) durante 
1 segundo. O endereço de memoria (write adress) fica como entrada (Sw8-4), e sua visualização no (HEX5-4) 
e data-in como entrada (Sw3-0) e visualização (HEX1). Também foi utilizando um clock de 50 MHz e um reset (Key0).
