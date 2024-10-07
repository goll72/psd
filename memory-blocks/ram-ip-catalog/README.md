ram-ip-catalog
==============

Foi implementada uma mémoria RAM com capacidade para 32 palavras de 4 bits (32 x 4). 
A implementação utiliza um módulo embutido do Intel Quartus. Quanto às portas, além do *clock*,
há uma porta `address`, que recebe o endereço ao qual se refere a operação atual, `wren` para
habilitar escrita, `data` para escrever no endereço especificado em `address` e `q` para ler do
endereço especificado em `address`.

## Demonstração na placa FPGA

Para demonstrar o funcionamento da RAM, foi vinculado entradas e saídas na placa FPGA da seguinte maneira:

 - Os *switches* *SW3−0* foram utilizados para fornecer a entrada *DataIn*, dado a ser armazenado.
 - Os *switches* *SW8−4* foram utilizados para fornecer a entrada *Address*, endereço onde o dado será armazenado.
 - O *switch* *SW9* foi utilizado para fornecer a entrada *WriteEnable*, que define se o dado será escrito ou lido.
 - O botão *KEY0* foi utilizado como *clock*.
 - O dado é exibido por um conjunto de 4 *LEDs*.
