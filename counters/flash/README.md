flash
=====

Na parte III do exercício 4, pede-se que seja implementado
um circuito com dois contadores que exiba um dígito em um
display de sete segmentos, incrementando o dígito exibido 
em intervalos de aproximadamente um segundo.

Um contador de n bits leva 2^n ciclos de clock para dar 
overflow. Usaremos um clock de 50MHz = $ 1/(50 \cdot 10^6) $.
Logo, 
$ 1 \approx 2^n/(50 \cdot 10^6) \implies n \approx log_2 (50 \cdot 10^6) $
Portanto, $ n \approx 25.575 $.

*Obs: com n = 25, o contador maior leva aprox. 0.67s para dar
overflow, enquanto com n = 26 ele leva aprox. 1.34s*
