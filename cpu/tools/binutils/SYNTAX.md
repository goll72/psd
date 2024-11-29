# Sintaxe

O assembler é *case-insensitive* (não há diferenciação entre texto em *lowercase* ou *uppercase*)

## Comentários

Comentários são iniciados com o caractere `#` ou `;` e vão até o final da linha atual.

## Rótulos

Para adicionar um rótulo/*label* a uma seção do código, basta usar o nome do rótulo seguido
por `:` (sem espaço), no começo de uma linha. Dessa forma, ocorrências do rótulo no assembly
(que podem vir antes da própria definição do rótulo) serão substituídas pelo endereço do código
imediatamente após o rótulo. Pode ou não haver código na mesma linha que um rótulo.

O único local onde rótulos podem ser usados no código é como operando para as instruções de salto.

## Registradores

Os registradores A, B e R podem ser referidos diretamente pelo seu nome (ex. `a`).

## Imediatos e literais

Imediatos/literais numéricos podem ser especificados em decimal (sem prefixo), binário 
(prefixo `0b`), octal (prefixo `0o`) ou hexadecimal (prefixo `0x`). Uso do operador unário 
`-` para realizar complemento de dois do imediato não é suportado. Imediatos sempre devem
ser valores que caibam em 8 *bits*.

## Instruções

Em cada linha deve haver no máximo uma instrução. As instruções suportadas podem ter nenhum, 
um ou dois operandos. Quando houver dois operandos, o segundo operando será uma especificação 
de registrador ou um imediato.

Além disso, quando houver dois operandos, o primeiro operando deve ser separado do segundo usando 
o caractere `,`. A separação entre a instrução e o primeiro operando é feita por espaço.

### Nenhum operando

As instruções com nenhum operando são:

 - `wait`
 - `nop`

### Um operando

As instruções com um operando são:

 - `not`
 - `in`
 - `out`
 - `jmp`
 - `jeq`
 - `jgr`

Para as instruções `not`, `in` e `out`, o operando deve ser um registrador.
Para as demais (instruções de salto), o operando deve ser um rótulo.

### Dois operandos

As instruções com dois operandos são:

 - `and`
 - `or`
 - `add`
 - `sub`
 - `cmp`
 - `load`
 - `store`
 - `mov`

### Comandos adicionais

O comando `byte` recebe dois operandos, ambos literais numéricos: o primeiro é 
um endereço e o segundo é um valor a ser armazenado nesse endereço na memória.

