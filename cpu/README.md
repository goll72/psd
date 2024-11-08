cpu
===

## Notas

Caso queira compilar, simular e executar os testbenches do projeto (em especial 
a unidade de testbench `tests/sim.vhdl`) usando o GHDL, será necessário usar o
GHDL 4, com a backend mcode, uma vez que versões anteriores e outras backends 
não suportam o uso de "external names", e irão abortar com mensagens de erro, 
como dereferência de ponteiro `NULL`.
