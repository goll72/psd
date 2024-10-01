# RAM
Nessa atividade foi implementado uma mémoria RAM com capacidade 32 x 4 (32 palavras de 4 bits), a implementação foi feita utilizando um módulo pré construido em
bibliotecas do Quartus, ele utiliza registradores para as entradas de "*Adress*" (endereço que será armazenado), "*DataIn*" (dado que será armazenado) 
e "*Write*" (entrada que define se o dado será escrito ou lido). A saída é definida como "*DataOut*" que retorna um dado.
## Demonstração na placa FPGA
Para demonstrar o funcionamento da RAM, foi vinculado entradas e saídas na placa FPGA da seguinte maneira: <br/> <br/>
Os *switches* *SW3−0* foram utilizados para fornecer a entrada *DataIn*, dado a ser armazenado.<br/>
Os *switches* *SW8−4* foram utilizados para fornecer a entrada *Adress*, endereço onde o dado será armazenado.<br/>
O *switch* *SW9* foi utilizado para fornecer a entrada *Adress*, que define se o dado será escrito ou lido.<br/>
O botão *KEY0* foi utilizado como *Clock*.<br/>
O dado é exibido por um conjunto de 4 *LEDS*.
