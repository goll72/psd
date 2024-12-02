cpu
===

Uma CPU de 8 bits descrita em VHDL, aplicando os conceitos de máquina de estados
abordados em Sistemas Digitais. Projeto final de Prática em Sistemas Digitais. 

## Estrutura

 - `demos`: programas em assembly (`.s`) demonstrando o funcionamento da CPU,
 além de casos de teste (entradas, `.in`) para cada programa para realizar testes
 usando a testbench `tests/sim.vhdl`.
 - `rtl`: código VHDL descrevendo a CPU e componentes auxiliares.
 - `tools`: ferramentas para facilitar o desenvolvimento e teste da CPU.
 - `tests`: testbenches.

## Compilação

O projeto em si e utilitários auxiliares podem ser compilados, executados e 
testados no Windows ou no GNU/Linux.

### Dependências

 - Python 3.10+ (para rodar o assembler, `as.py`, e o `objdump.py`)
 - GNU make (para rodar os comandos de compilação e testbenches automaticamente)
 - Um compilador C que suporte C99 (para compilar o simulador da CPU)
 - MinGW (para compilar o simulador para Windows no GNU/Linux)

Você já deve saber como instalar essas dependências no GNU/Linux. No Windows, para
não perder tempo, você pode usar o script `bootstrap.bat` disponibilizado nesse
repositório para instalar o GNU make do ezwinports e o Python do projeto cosmos
(cosmopolitan libc).

> [!NOTE]
> No Windows, o Python instalado em `C:\windows\py.exe` será usado, se existir.
> Certifique-se de que a versão do Python usada é 3.10 ou superior. Se necessário,
> especifique o caminho para o executável do intepretador Python manualmente usando
> a variável `PYTHON` ou use o script `bootstrap.bat`.

#### Simulador

Um executável do simulador para Windows é disponibilizado como um release no GitHub. 
Para baixá-lo:

```sh
make -C tools/sim sim.exe
```

Caso queira compilar o simulador para Windows no GNU/Linux, use o mesmo comando acima.
Caso queira compilar o simulador para Windows no Windows, rode o comando de compilação manualmente.

Para compilar o simulador no GNU/Linux, use:

```sh
make -C tools/sim sim
```

### Alvos e variáveis de compilação

As seguintes variáveis podem ser passadas como argumento ao executar o comando `make`:

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
 - `clean`: remove os artefatos de compilação/síntese/teste.
 - `defaults`: imprime os valores de algumas variáveis que podem ser úteis.

Alguns alvos adicionais, que se referem diretamente a arquivos, podem ser usados:

 - `%.bin`: usa o assembler para gerar um arquivo `.bin` e um arquivo `.mif` 
 a partir do arquivo que possui o mesmo prefixo do alvo, porém com a extensão `.s`.  
 Exemplo: `make demos/add.bin` irá montar o arquivo `demos/add.s`, gerando
 `demos/add.bin` e `demos/add.mif`.

 - `%.mif`: idem.

 - `%.ok`: roda apenas o teste da testbench `tests/sim.vhdl` correspondente ao arquivo
 com o mesmo prefixo do alvo, porém com a extensão `.in`.  
 Exemplo: `make demos/add.dir/0.ok` irá rodar o teste que consiste em rodar o simulador
 C com a memória inicializada por `demos/add.bin`, entradas dadas em `demos/add.dir/0.in`,
 salvar as saídas em `demos/add.dir/0.out` e salvar um dump do estado do simulador em
 `demos/add.dir/0.sim.dump`, e então rodar o testbench `tests/sim.vhdl` com as mesmas
 entradas e, por fim, comparar as saídas e o dump do estado (registradores e memória).

Por exemplo, `make ENV=nvc TEST_SIM_ABORT_ON_ERROR=1 test` irá preparar todos os arquivos
necessários e rodar os casos de teste que ainda não foram rodados ou que não passaram na
última vez que foram rodados, usando o simulador de VHDL `nvc` e abortando a execução caso
algum caso de teste da testbench `tests/sim.vhdl` falhe.

> [!IMPORTANT]
> Devido à forma que os makefiles são estruturados, é necessário passar a variável `ENV`
> ao rodar qualquer comando, mesmo aqueles que não tenham relação alguma com VHDL. Para
> esses comandos, qualquer valor dentre os valores permitidos pode ser usado. O valor
> `common` também pode ser usado nesses casos, se você preferir.

## Programando a placa FPGA

O projeto foi desenvolvido e testado na placa FPGA DE0-CV, portanto as atribuições de
pinos no arquivo `.qsf` do projeto já estão configuradas para uso com essa placa.

Normalmente (para os outros projetos nesse repositório) basta rodar `make ENV=quartus run`
para realizar a síntese e programar a placa FPGA, usando o Quartus. No entanto, para esse
projeto, há a possibilidade de escolha entre vários arquivos `.mif` para inicializar a
memória. Essa escolha pode (e deve) ser feita usando a variável `MIF_FILE`. Por exemplo:

```sh
make ENV=quartus MIF_FILE=demos/fibonacci.mif run
```

Desde que haja um arquivo `.s` correspondente, o comando acima irá montar esse arquivo e
gerar o arquivo `.mif`, caso ainda não exista ou esteja desatualizado, para então proceder
com a síntese e a programação da placa FPGA.

> [!NOTE]
> O makefile irá copiar o arquivo `.mif` especificado para um outro arquivo com nome
> `current.mif`, e irá criar um arquivo `current.mif.d`. Caso você ainda prefira compilar 
> o projeto e programar a placa FPGA manualmente, pela interface gráfica do Quartus, basta 
> criar o arquivo `current.mif` (o arquivo `current.mif.d` é usado internamente no
> makefile apenas para rastreamento de dependências).

Uma vez que a variável `MIF_FILE` foi especificada, pode ser omitida em execuções 
subsequentes do `make run` para usar o mesmo arquivo `.mif`.

## Usando o assembler

Como já mencionado na seção sobre [alvos de compilação](#alvos-e-variáveis-de-compilação),
arquivos em assembly (`.s`) podem ser compilados usando o comando `make ENV=common file.bin`
(supondo que exista um arquivo assembly `file.s`). Também é possível invocar o assembler 
manualmente rodando o programa `./tools/binutils/as.py` com algum interpretador Python.

Para ler sobre a sintaxe suportada no assembly, [clique aqui](./tools/binutils/SYNTAX.md).

## Funcionamento da CPU

Para uma explicação mais detalhada do funcionamento, detalhes da implementação da CPU
e instruções implementadas, confira [o relatório](report.tex).

## Notas

Para que seja possível usar os makefiles para compilar o projeto, é necessário
que os programas de cada ambiente estejam disponíveis no caminho de busca 
(variável de ambiente `PATH`). Essas ferramentas são:

 - `ghdl`: `ghdl`/`ghdl-gcc`/`ghdl-llvm`/`ghdl-mcode`
 - `nvc`: `nvc`
 - `modelsim`: `vcom`, `vsim`, `vlib`
 - `quartus`: `quartus_sh`, `quartus_pgm`

> [!NOTE]
> No Windows, esses programas terão a extensão `.exe`.

Os makefiles foram feitos para funcionar nos PCs do lab 6-305/6, usando o local
de instalação padrão do Quartus e do Modelsim. Em outros contextos, pode ser
necessário atribuir a variável de ambiente `PATH` manualmente.

No Windows, cmd:

```
set PATH=%PATH%;...
```

No Windows, powershell:

```powershell
$env:Path += ';...'
```

No GNU/Linux, bash/sh:

```sh
PATH=$PATH:...
```

Caso queira compilar, simular e executar os testbenches do projeto (em especial 
a unidade de testbench `tests/sim.vhdl`) usando o GHDL, será necessário usar o
GHDL 4, com a backend mcode, uma vez que versões anteriores e outras backends 
não suportam o uso de "external names", podendo abortar com mensagens de erro, 
como dereferência de ponteiro `NULL`.
