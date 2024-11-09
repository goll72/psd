cpu
===

Uma CPU de 8 bits descrita em VHDL, aplicando os conceitos de máquina de estados
abordados em Sistemas Digitais. Projeto final de Prática em Sistemas Digitais. 

## Compilação

O projeto em si e utilitários auxiliares podem ser compilados, executados e 
testados no Windows ou no GNU/Linux.

### Dependências

 - Python 3.10+ (para rodar o assembler, `as.py`, e o `objdump.py`)
 - GNU make (para rodar os comandos de compilação e testbenches automaticamente)
 - Um compilador C que suporte C99 (para compilar o simulador da CPU)
 - MinGW (para compilar o simulador para Windows no GNU/Linux)

Você já deve saber como instalar essas dependências no GNU/Linux. No Windows, para
não perder tempo, você pode usar o script `./scripts/bootstrap.bat` disponibilizado
nesse repositório para instalar o GNU make do ezwinports e o Python do projeto cosmos
(cosmopolitan libc).

#### Simulador

Um executável do simulador para Windows é disponibilizado como um release no GitHub. 
Para baixá-lo:

```sh
cd ./tools/sim && make sim.exe
```

Caso queira compilar o simulador para Windows no GNU/Linux, use o mesmo comando acima.
Caso queira compilar o simulador para Windows no Windows, rode o comando de compilação manualmente.

Para compilar o simulador no GNU/Linux, use:

```sh
cd ./tools/sim && make sim
```

### Alvos e variáveis de compilação

As seguintes variáveis podem ser passadas ao executar o comando `make`:

 - `ENV`: (obrigatório) determina o ambiente usado para compilação/síntese/teste.
 Possíveis valores: `ghdl`, `nvc`, `modelsim`, `quartus`
 - `WORK`: local onde os arquivos da biblioteca `work` serão salvos.
 Padrão: `work/$(ENV)` (não é usado quando `ENV=quartus`)
 - `TOPLEVEL`: entidade de design top-level
 - `TEST_SIM_ABORT_ON_ERROR`: se for especificada, caso algum teste usando a harness
 `tests/sim.vhdl` falhe, os demais testes não serão executados.
 - ... (específicas a cada ambiente)

Os seguintes alvos podem ser executados:

 - `all`: (padrão) realiza a compilação/síntese no ambiente especificado.
 - `run`: roda a simulação ou, no ambiente `quartus`, programa a placa FPGA 
 (assumindo que há apenas uma placa conectada).
 - `test`: roda os testbenches disponibilizados em `tests/`. Obviamente,
 apenas os ambientes de simulação são suportados.
 - `clean`: remove os aretefatos de compilação/síntese/teste.
 - `defaults`: imprime os valores de algumas variáveis que podem ser úteis.

## Notas

Para que seja possível usar os makefiles para compilar o projeto, é necessário
que as ferramentas de cada ambiente estejam disponíveis no caminho de busca 
(variável de ambiente `PATH`). Essas ferramentas são:

 - `ghdl`: `ghdl`/`ghdl-gcc`/`ghdl-llvm`/`ghdl-mcode`
 - `nvc`: `nvc`
 - `modelsim`: `vcom`, `vsim`, `vlib`
 - `quartus`: `quartus_sh`, `quartus_pgm`

Os makefiles foram feitos para funcionar nos PCs do lab 6-305/6, usando o local
de instalação padrão do Quartus e do Modelsim. Em outros contextos, pode ser
necessário atribuir a variável de ambiente `PATH` manualmente.

No Windows, cmd:

```
set PATH=%PATH%;...
```

No Windows, powershell:

```
$env:Path += ...
```

No GNU/Linux, bash:

```
PATH=$PATH:...
```

Caso queira compilar, simular e executar os testbenches do projeto (em especial 
a unidade de testbench `tests/sim.vhdl`) usando o GHDL, será necessário usar o
GHDL 4, com a backend mcode, uma vez que versões anteriores e outras backends 
não suportam o uso de "external names", podendo abortar com mensagens de erro, 
como dereferência de ponteiro `NULL`.
