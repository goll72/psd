sim
===

Simulador da CPU a ser implementada nesse projeto.

## Observações

As instruções `in` e `out` são implementadas por meio
das streams `stdin` e `stdout`. Os caracteres representando
cada bit são sempre lidos/escritos começando pelo MSB. Para
a instrução `in`, qualquer caractere que não seja `0` ou `1`
é descartado.

Os dumps do estado da simulação são realizados pela stream
`stderr`, para facilitar a integração com outras ferramentas.

A instrução `wait` é implementada usando sinais: a recepção do
sinal SIGINT corresponde a uma interrupção. Caso o sinal seja
recebido mais de uma vez em um curto intervalo de tempo, o 
simulador fechará. A implementação dessa instrução pode ser
desabilitada usando a opção `-n`.

Um caractere `$` é impresso para indicar que o simulador está
aguardando uma entrada (instrução `in`), `@` é impresso para
indicar aguardo de uma interrupção (instrução `wait`) e `>` é
impresso para denotar uma saída.
