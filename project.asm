
; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS    EQU 0A000H  ; endereco dos displays de 7 segmentos (periferico POUT-1)
TEC_LIN     EQU 0C000H  ; endereco das linhas do teclado (periferico POUT-2)
TEC_COL     EQU 0E000H  ; endereco das colunas do teclado (periferico PIN)
LINHA_TEST  EQU 16      ; linha a testar (comecamos na 4a linha, mas por causa do shift right inicial inicializamos ao dobro)
MASCARA     EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TSUB        EQU 00010001b ; tecla para subtrair a energia
TADD        EQU 00010010b ; tecla para adicionar a energia
TMOVESQ     EQU 10000001b ; tecla para mover nave para a esquerda
TMOVDIR     EQU 10000100b ; tecla para mover nave para a direita
TMOVINIM    EQU 01000010b ; tecla para mover meteoro para baixo

ENERGIA     EQU 064H    ; valor inicial da energia
SENERGIA    EQU 05H     ; valor de energia a subtrair

SEL_LINHA   EQU 600AH   ; endereco do comando para definir a linha
SEL_COLUNA  EQU 600CH   ; endereco do comando para definir a coluna
SEL_PIXEL   EQU 6012H   ; endereco do comando para escrever um pixel
DEL_AVISO   EQU 6040H   ; endereco do comando para apagar o aviso de nenhum cenario selecionado
BACKGROUND  EQU 6042H   ; endereco do comando para selecionar uma imagem de fundo

MIN_COLUNA  EQU 0       ; numero da coluna mais a esquerda que o objeto pode ocupar
MAX_COLUNA  EQU 64      ; numero da coluna mais a direita que o objeto pode ocupar
MIN_LINHA   EQU 0       ; numero da linha mais acima que o objeto pode ocupar
MAX_LINHA   EQU 32      ; numero da linha mais abaixo que o objeto pode ocupar

DELAY       EQU 1800H   ; atraso para limitar a velocidade de movimento da nave

NAVE_X      EQU 30      ; coluna da nave
NAVE_Y      EQU 28      ; linha da nave
NAVE_LX     EQU 5       ; largura da nave
NAVE_LY     EQU 4       ; altura da nave

INIMIGO_X   EQU 20
INIMIGO_Y   EQU 3
INIMIGO_LX  EQU 5
INIMIGO_LY  EQU 5

YELLOW      EQU 0FFF0H  ; cor amarelo em ARGB
RED         EQU 0FF00H  ; cor vermelho em ARGB

; #######################################################################
; * ZONA DE DADOS
; #######################################################################
PLACE       1000H
pilha:
    STACK 100H          ; espaco reservado para a stack
SP_inicial:             ; este e o endereço com que o SP deve ser inicializado (1200H)

def_nave:               ; tabela que define a nave (largura, altura e cor dos pixeis)
    WORD    NAVE_X
    WORD    NAVE_Y
    WORD    NAVE_LX
    WORD    NAVE_LY
    WORD    0, 0, YELLOW, 0, 0
    WORD    YELLOW, 0, YELLOW, 0, YELLOW
    WORD    YELLOW, YELLOW, YELLOW, YELLOW, YELLOW
    WORD    0, YELLOW, 0, YELLOW, 0

def_inimigo:            ; tabela que define o inimigo (largura, altura e cor dos pixeis)
    WORD    INIMIGO_X
    WORD    INIMIGO_Y
    WORD    INIMIGO_LX
    WORD    INIMIGO_LY
    WORD    RED, 0, 0, 0, RED
    WORD    RED, 0, RED, 0, RED
    WORD    0, RED, RED, RED, 0
    WORD    RED, 0, RED, 0, RED
    WORD    RED, 0, 0, 0, RED

; **********************************************************************
; * Codigo
; **********************************************************************
PLACE      0
inicio:
; inicializacoes
    MOV SP, SP_inicial  ; inicializar o stack pointer com o endereco 1200H
    MOV R2, TEC_LIN     ; endereco do periferico das linhas
    MOV R3, TEC_COL     ; endereco do periferico das colunas
    MOV R4, DISPLAYS    ; endereco do periferico dos displays
    MOV R5, MASCARA     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV R6, ENERGIA     ; valor inicial da energia
    ; R7 -> auxiliar para passar argumentos

; corpo principal do programa
main:
; setup inicial do ecra
    MOV [R4], R6        ; escreve a energia nos displays
    MOV [DEL_AVISO], R0 ; apaga o aviso de nenhum cenario selecionado
    MOV R0, 0           ; cenário de fundo numero 0
    MOV [BACKGROUND], R0; seleciona o cenario de fundo
    PUSH R2

    ; nave
    MOV R7, def_nave
    PUSH R7             ; argumentos da rotina desenha_objeto para nave inicial
    CALL desenha_objeto ; desenhar nave
    POP R7              ; POP ao argumento

    ; inimigo
    MOV R7, def_inimigo
    PUSH R7             ; argumentos da rotinha desenha_objeto para inimigo inicial
    CALL desenha_objeto ; desenhar inimigo
    POP R7              ; POP ao argumento

; executa principais funcoes (nota: falta implementar como processos)
    CALL espera_tecla

espera_tecla:
; espera uma tecla ser premida e executa a funcao correspondente
;sem argumentos
    MOV  R1, LINHA_TEST ; comecar por testar a linha 4
loop_espera:
    SHR R1, 1           ; shift right
    CMP R1, 0           ; verificar se estamos a testar uma linha valida
    JZ  espera_tecla    ; reinicializar o valor da linha e recomecar o ciclo caso linha seja invalida
    MOVB [R2], R1       ; escrever no periferico de saída (linhas)
    MOVB R0, [R3]       ; ler do periferico de entrada (colunas)
    AND R0, R5          ; elimina bits para além dos bits 0-3
    CMP R0, 0           ; ha tecla premida?
    JZ  loop_espera     ; se nenhuma tecla premida, repete
    MOV R9, R1          ; guardar o valor da linha
    SHL R1, 4           ; coloca linha no nibble high
    OR  R1, R0          ; junta coluna (nibble low)

    ; caso subtrai_energia
    MOV R0, TSUB        ; agora R0 tem as coordenadas da tecla que subtrai a energia
    CMP R1, R0          ; verifica se carregamos nessa tecla
    JZ subtrai_energia  ; efetuar a operacao caso tenha sido pressionada

    ; caso adiciona_energia
    MOV R0, TADD        ; agora R0 tem as coordenadas da tecla que adiciona a energia
    CMP R1, R0          ; verifica se carregamos nessa tecla
    JZ adiciona_energia ; efetuar a operacao caso tenha sido pressionada

    ; caso move para esquerda
    MOV R0, TMOVESQ     ; agora R0 tem as coordenadas da tecla que move a nave para a esquerda
    MOV R9, -1          ; prepara argumento para move_nave (-1 para esquerda)
    MOV R8, def_nave
    CMP R1, R0           ; verifica se carregamos nessa tecla
    JZ move_objeto       ; efetuar a operacao caso tenha sido pressionada

    ; caso move para direita
    MOV R0, TMOVDIR     ; agora R0 tem as coordenadas da tecla que move a nave para a direita
    MOV R9, 1           ; prepara argumento para move_nave (1 para direita)
    MOV R8, def_nave
    CMP R1, R0          ; verifica se carregamos nessa tecla
    JZ move_objeto      ; efetuar a operacao caso tenha sido pressionada

    ; caso move inimigo para baixo
    MOV R0, TMOVINIM
    MOV R9, 2           ; prepara argumento para move_nave (2 para baixo)
    MOV R8, def_inimigo
    CMP R1, R0
    JZ move_objeto
largou:                 ; neste ciclo espera-se ate largar a tecla
    MOVB [R2], R9       ; escrever no periferico de saída (linhas)
    MOVB R0, [R3]       ; ler do periferico de entrada (colunas)
    AND  R0, R5         ; elimina bits para além dos bits 0-3
    CMP R0, 0           ; ha tecla premida?
    JNZ largou          ; se ainda houver uma tecla premida repete o loop
    JMP espera_tecla    ; volta ao da funcao

delay:
	PUSH R0
    MOV R0, DELAY
ciclo_delay:
	SUB R0, 1
	JNZ	ciclo_delay
	POP	R0
	RET

subtrai_energia:
    CMP R6, 0           ; ver se a nossa energia atual ja e o minimo
    JZ largou           ; caso seja o minimo nao fazemos nada
    MOV R0, -1          ; -1 porque queremos que muda_energia subtraia
    JMP muda_energia    ; mudar a energia

adiciona_energia:
    MOV R0, ENERGIA     ; valor maximo de energia
    CMP R6, R0          ; ver se a nossa energia atual ja e o maximo
    JZ largou           ; caso seja o maximo nao fazemos nada
    MOV R0, 1           ; 1 porque queremos que muda_energia adicione
    JMP muda_energia    ; mudar a energia

muda_energia:
; muda o valor da energia no display
; R0 -> -1 ou 1 consoante vamos subtrair ou adicionar energia
    MOV R1, SENERGIA    ; valor a subtrair
    MUL R1, R0          ; R1 vai ser -1 ou 1 consoante queremos aumentar ou diminuir
    ADD R6, R1          ; subtrair ou aumentar energia
    MOV [R4], R6        ; atualiza a energia nos displays
    JMP largou          ; espera que a tecla seja largada

move_objeto:
; move a objeto para a esquerda ou direita
;argumentos:
; R8 -> endereco da tabela que define os pixeis do objeto
; R9 -> direcao (1 = direita, -1 = esquerda, -2 = cima, 2 = baixo)
    PUSH R2
    PUSH R3
    ; verificar para que lado se vai mover
    CMP R9, 1
    JZ verificacao_direita
    CMP R9, 2
    JZ verificacao_baixo
verificacao_esquerda:
    MOV R2, [R8]        ; obtem posicao atual
    CMP R2, MIN_COLUNA  ; verifica se ja esta na posicao mais a esquerda
    JZ fim_move_objeto
    JMP move_x
verificacao_direita:
    ; verifica se ja esta no canto do ecra (direita)
    MOV R2, [R8]        ; obtem posicao atual
    MOV R3, [R8+4]      ; obtem largura da nave
    ADD R2, R3          ; adiciona largura
    MOV R3, MAX_COLUNA  ; largura do ecra
    CMP R2, R3          ; verifica se ja esta na posicao mais a direita
    JZ fim_move_objeto
    JMP move_x
verificacao_baixo:
; meter aqui codigo que remove da tabela de objetos caso objeto avance pa fora

    JMP move_y
    CALL apaga_objeto
move_x:
    PUSH R8             ; argumentos da rotina apaga_objeto para objeto
    CALL apaga_objeto   ; apagar objeto
    POP R7              ; POP ao argumento
    MOV R7, [R8]        ; obter coordenada atual
    ADD R7, R9          ; obter a nova coordenada
    MOV [R8], R7        ; atualiza posicao objeto
    PUSH R8             ; argumentos da rotina desenha_objeto para voltar a desenhar a objeto
    CALL desenha_objeto ; desenhar objeto
    POP R7              ; POP ao argumento
    JMP fim_move_objeto ; terminar
move_y:
    SHRA R9, 1          ; dividir por 2 o argumento preservando o sinal
    PUSH R8             ; argumentos da rotina apaga_objeto para objeto
    CALL apaga_objeto   ; apagar objeto
    POP R7
    MOV R7, [R8+2]      ; obter coordenada atual
    ADD R7, R9          ; obter a nova coordenada
    MOV [R8+2], R7      ; atualiza posicao objeto
    PUSH R8          ; argumentos da rotina desenha_objeto para voltar a desenhar a objeto
    CALL desenha_objeto ; desenhar objeto
    POP R7
fim_move_objeto:
    POP R3
    POP R2
    CALL delay          ; delay no movimento
    JMP espera_tecla    ; volta ao inicio

desenha_objeto:
; desenha um objeto
;argumentos (stack):
; 1 -> endereco da tabela que define os pixeis do objeto
    PUSH R0
    MOV R0, [SP+4]
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    MOV R3, [R0 + 4]    ; obtem a largura do objeto
    MOV R4, [R0 + 6]    ; obtem a altura do objeto
    MOV R1, [R0]        ; coluna inicial
    MOV R2, [R0+2]      ; linha inicial
    ADD R3, R1          ; coluna final
    ADD R4, R2          ; linha final
    MOV R7, 8
    ADD R0, R7          ; endereco da cor do primeiro pixel
    MOV R5, R1          ; copia das coordenadas iniciais da coluna
desenha_colunas:        ; desenha os pixels do boneco a partir da tabela
    MOV R6, [R0]        ; obtem a cor do proximo pixel
    MOV [SEL_COLUNA], R1; seleciona a coluna
    MOV [SEL_LINHA], R2 ; seleciona a linha
    MOV [SEL_PIXEL], R6 ; altera a cor do pixel na linha e coluna selecionadas
    ADD R0, 2           ; endereco da cor do proximo pixel
    ADD R1, 1           ; proxima coluna
    CMP R1, R3          ; verificar se ja tratamos da largura toda
    JNZ desenha_colunas ; continua ate percorrer toda a largura do objeto
    ADD R2, 1           ; proxima linha
    MOV R1, R5          ; reiniciar as colunas
    CMP R2, R4          ; verificar se ja tratamos da altura toda
    JNZ desenha_colunas ; continuar ate tratar da altura toda
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET

apaga_objeto:
; apaga um objeto
;argumentos (stack):
; 1 -> endereco da tabela que define os pixeis do objeto
    PUSH R0
    MOV R0, [SP+4]
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    MOV R3, [R0 + 4]    ; obtem a largura do objeto
    MOV R4, [R0 + 6]    ; obtem a altura do objeto
    MOV R1, [R0]        ; coluna inicial
    MOV R2, [R0+2]      ; linha inicial
    ADD R3, R1          ; coluna final
    ADD R4, R2          ; linha final
    MOV R5, R1          ; copia das coordenadas iniciais da coluna
apaga_colunas:          ; desenha os pixels do boneco a partir da tabela
    MOV [SEL_COLUNA], R1; seleciona a coluna
    MOV [SEL_LINHA], R2 ; seleciona a linha
    MOV R0, 0           ; escolhe cor 0 (apagar)
    MOV [SEL_PIXEL], R0 ; apaga o pixel na linha e coluna selecionadas
    ADD R1, 1           ; proxima coluna
    CMP R1, R3          ; verificar se ja tratamos da largura toda
    JNZ apaga_colunas   ; continua ate percorrer toda a largura do objeto
    ADD R2, 1           ; proxima linha
    MOV R1, R5          ; reiniciar as colunas
    CMP R2, R4          ; verificar se ja tratamos da altura toda
    JNZ apaga_colunas   ; continuar ate tratar da altura toda
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET
