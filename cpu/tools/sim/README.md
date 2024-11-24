sim
===

Simulador da CPU implementada nesse projeto.

## Observações

As instruções `in` e `out` são implementadas por meio
das streams `stdin` e `stdout`. Os caracteres representando
cada bit são sempre lidos/escritos começando pelo MSB. Para
a instrução `in`, qualquer caractere que não seja `0` ou `1`
é descartado.

Os dumps do estado da simulação são realizados pela stream
`stderr`, para facilitar a integração com outras ferramentas.

A instrução `wait` é implementada usando a condição EOF da stream
`stdin`. Essa condição pode ser habilitada no Windows ao pressionar
Ctrl+Z ou, no Linux, ao pressionar Ctrl+D, assumindo que `stdin`
se refere a um terminal (o simulador está sendo usado interativamente).
Para uso não interativo, a opção `-n` desabilita a impressão de prompts
e procede imediatamente ao executar a instrução `wait`.

Se a opção `-n` não for especificada, um caractere `$` será impresso 
para indicar que o simulador está aguardando uma entrada (instrução `in`), 
`@` para indicar aguardo de uma interrupção (instrução `wait`) e `>` será
impresso para denotar uma saída.
