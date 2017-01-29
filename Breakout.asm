INCLUDE ..\Irvine32.inc
INCLUDE ..\Macros.inc   ;Necessário pra usar função de debug mShow

.data
posAtual_x    BYTE  0
posAtual_y    BYTE  0   ;apesar de n precisarmos, deixei o y caso no futuro
posAnterior_x BYTE  0   ;a gente consiga fazer mais fases e mude a posicao da prancha
posAnterior_y BYTE  0

.code
main PROC
      mov dl, 0         ;Previne erros com Gotoxy
      mov dh, 0

      mov al, 254       ;Iniciando posição zero do quadrado (■)
      call WriteChar    ;Printando quadrado

ProcuraTecla:
      mov eax, 50       ;Passa 0.05 segundos de Delay
      call Delay        ;para melhorar leitura de teclas
      call ReadKey      ;Leitura de tecla
      jz ProcuraTecla   ;Leia até tecla ser pressionada

      cmp ah, 4Dh       ;Compara com seta direita
      je Direita
      cmp ah, 4Bh       ;Compara com seta esquerda
      je Esquerda

      jne TeclaNaoAceita

Direita:
      mov dl, posAtual_x      ;Atualiza posições atual e anterior
      mov posAnterior_x, dl
      inc posAtual_x
      dec dl
      jmp AttPos
Esquerda:
      mov dl, posAtual_x
      mov posAnterior_x, dl
      dec posAtual_x
      inc dl

AttPos:
      mov dh, posAnterior_y   ;Volta a duas posições anteriores e apaga.
      call Gotoxy             ;É necessário apagar as duas últimas posições
      mov al, 0               ;por existir um bug com o print no console
      call WriteChar          ;que deixa espécie de rastro do último print

      mov dl, posAnterior_x   ;Vai na posição anterior com cursor
      mov dh, posAnterior_y   ;e apaga o char que está printado lá
      call Gotoxy

      mov al, 0               ;Caractere branco
      call WriteChar

      mov dl, posAtual_x      ;Por fim, printamos o char na posição atual
      mov dh, posAtual_y
      call Gotoxy
      mov al, 254             ;Reescreve quadrado (■)
      call WriteChar

TeclaNaoAceita:
      jmp ProcuraTecla



EXIT_GAME:
      call ReadChar     ;Espera tecla para fechar programa

    exit
main ENDP

END main
