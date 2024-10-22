psd
===

Contém os códigos e relatórios referentes aos projetos desenvolvidos na 
disciplina de Prática em Sistemas Digitais.

Os projetos podem ser "compilados" (no jargão VHDL, analisados e elaborados)
para simulação nos seguintes ambientes:

 - GHDL
 - ModelSim
 - NVC

Adicionalmente, os projetos podem ser compilados usando o Intel Quartus Prime 
a fim de gerar um arquivo `.sof` que pode ser programado em dispositivos SoC
FPGA Cyclone.

Nos quatro ambientes citados, a compilação e execução do projeto pode ser feita 
manualmente, ou com uso de makefile:

```
$ make ENV=<env>
``` 

Onde `<env>` é um de `ghdl`, `modelsim`, `nvc` ou `quartus`.

 - `make clean` pode ser utilizado para remover artefatos de compilação
 - `make run` pode ser utilizado para iniciar um ambiente de simulação
 ou, no ambiente `quartus`, programar o dispositivo FPGA.

No ambiente `quartus`, o alvo `netlist` (`make netlist`) é disponibilizado
para executar o Intel Quartus Prime Netlist Viewer.

## Projetos

### [latch-ff-register](./latch-ff-register)

Desenvolvido durante as aulas de 20/09/2024 e 29/09/2024.

### [counters](./counters)

Desenvolvido durante as aulas de 10/09/2024 e 17/09/2024. 

### [morse](./morse)

Desenvolvido durante a aula de 24/09/2024.

### [memory-blocks](./memory-blocks)

Desenvolvido durante a aula de 01/10/2024.

### [fsm](./fsm)

Desenvolvido durante as aulas de 08/10/2024 e 15/10/2024.
