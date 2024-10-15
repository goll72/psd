ram-VHDL
==============

Invés de criar um bloco de memória, implementamos uma matriz com 32 linhas e 4 colunas, simulando a ram32x4,
utilizando as mesmas entradas e saídas do exercicio part II (ram-Display), observando os mesmos resultados do exercício anterior.

## Demonstração na placa FPGA

Para demonstrar o funcionamento na placa FPGA, foi vinculado entradas e saídas da seguinte maneira:

 - Os *switches* *SW3−0* foram utilizados para fornecer a entrada *DataIn*, dado a ser armazenado.
 - Os *switches* *SW8−4* foram utilizados para fornecer a entrada *Address*, endereço onde o dado será armazenado.
 - O *switch* *SW9* foi utilizado para fornecer a entrada *WriteEnable*, que define se o dado será escrito ou lido.
 - O botão *KEY0* foi utilizado como *clock*.
 - O Valor do Endereço é exibido no conjunto de display de 7 segmentos (HEX5-4).
 - Data input é mostrado no no display HEX2
 - Data read é mostrado no display HEX0
