ram-displays
==============

Foi implementado um novo arquivo em VHDL, que instância o modulo ram32x4 feito na part I dessa aula, com a mudança
de exibir nos displays o endereço de entrada, o dado lido nesse endereço e o dado a ser copiado.

## Demonstração na placa FPGA

Para demonstrar o funcionamento na placa FPGA, foi vinculado entradas e saídas da seguinte maneira:

 - Os *switches* *SW3−0* foram utilizados para fornecer a entrada *DataIn*, dado a ser armazenado.
 - Os *switches* *SW8−4* foram utilizados para fornecer a entrada *Address*, endereço onde o dado será armazenado.
 - O *switch* *SW9* foi utilizado para fornecer a entrada *WriteEnable*, que define se o dado será escrito ou lido.
 - O botão *KEY0* foi utilizado como *clock*.
 - O Valor do Endereço é exibido no conjunto de display de 7 segmentos (HEX5-4).
 - Data input é mostrado no no display HEX2
 - Data read é mostrado no display HEX0

