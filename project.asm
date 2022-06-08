
; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS    EQU 0A000H  ; endereco dos displays de 7 segmentos (periferico POUT-1)
TEC_LIN     EQU 0C000H  ; endereco das linhas do teclado (periferico POUT-2)
TEC_COL     EQU 0E000H  ; endereco das colunas do teclado (periferico PIN)
LINHA_TEST  EQU 16      ; linha a testar (comecamos na 4a linha, mas por causa do shift right inicial inicializamos ao dobro)
MASCARA     EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TSTART      EQU 10000001b ; tecla para comecar o jogo
TSUB        EQU 00010001b ; tecla para subtrair a energia
TADD        EQU 00010010b ; tecla para adicionar a energia
TMOVESQ     EQU 10000001b ; tecla para mover nave para a esquerda
TMOVDIR     EQU 10000100b ; tecla para mover nave para a direita
TMOVINIM    EQU 01000010b ; tecla para mover meteoro para baixo

MAX_ENERGIA EQU 064H    ; valor inicial da energia e maximo
MIN_ENERGIA EQU 0       ; valor minimo da energia
SENERGIA    EQU 05H     ; maximo divisor comum do valor de energia a subtrair e adicionar

HOME        EQU 0       ; estado em que o jogo esta (home screen)
JOGO        EQU 1       ; estado em que o jogo esta (a ser jogado)
BACKGROUND_JOGO EQU 0   ; imagem de fundo do jogo
BACKGROUND_HOME EQU 1   ; imagem de fundo do home screen

DEL_ECRAS   EQU 6002H   ; endereco do comando para apagar todos os ecras
SEL_LINHA   EQU 600AH   ; endereco do comando para definir a linha
SEL_COLUNA  EQU 600CH   ; endereco do comando para definir a coluna
SEL_PIXEL   EQU 6012H   ; endereco do comando para escrever um pixel
DEL_AVISO   EQU 6040H   ; endereco do comando para apagar o aviso de nenhum cenario selecionado
BACKGROUND  EQU 6042H   ; endereco do comando para selecionar uma imagem de fundo

TIRO        EQU 0       ; som do tiro
PLAY_SOM    EQU 605AH   ; endereco do comando para reproduzir um som

MIN_COLUNA  EQU 0       ; numero da coluna mais a esquerda que o objeto pode ocupar
MAX_COLUNA  EQU 63      ; numero da coluna mais a direita que o objeto pode ocupar
MIN_LINHA   EQU 0       ; numero da linha mais acima que o objeto pode ocupar
MAX_LINHA   EQU 31      ; numero da linha mais abaixo que o objeto pode ocupar

DELAY       EQU 2000H   ; atraso para limitar a velocidade de movimento da nave

NAVE_X      EQU 30      ; coluna da nave
NAVE_Y      EQU 28      ; linha da nave
NAVE_LX     EQU 5       ; largura da nave
NAVE_LY     EQU 4       ; altura da nave

INIMIGO_X   EQU 20      ; coluna do inimigo
INIMIGO_Y   EQU 3       ; linha do inimigo
INIMIGO_LX  EQU 5       ; largura do inimigo
INIMIGO_LY  EQU 5       ; altura do inimigo

YELLOW      EQU 0FFF0H  ; cor amarelo em ARGB
RED         EQU 0FF00H  ; cor vermelho em ARGB

; #######################################################################
; * ZONA DE DADOS
; #######################################################################
PLACE       1000H

    STACK 100H          ; espaco reservado para a stack do programa principal
sp_main:                ; este e o endereco com que o SP deve ser inicializado (1200H)

    STACK 100H          ; espaco reservado para a stack do processo que trata do teclado
sp_teclado:

    STACK 100H          ; espaco reservado para a stack do processo que trata do controlo
sp_controlo:

    STACK 100H          ; espaco reservado para a stack do processo que trata da energia
sp_energia:

    STACK 100H          ; espaco reservado para a stack do processo que trata do rover
sp_rover:

lock_controlo:          ; variavel para controlar o processo controlo
    LOCK    0

lock_energia:           ; variavel para controlar o processo energia
    LOCK    0

lock_rover:             ; variavel para controlar o processo rover
    LOCK    0

lock_main:
    LOCK    0

estado:
    WORD HOME           ; estado do jogo

def_rover:              ; tabela que define o rover (largura, altura e cor dos pixeis)
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
main:
; inicializacoes
    MOV SP, sp_main             ; inicializar o stack pointer com o endereco 1200H
; setup inicial do ecra
    MOV [DEL_ECRAS], R0
    MOV [DEL_AVISO], R0         ; apaga o aviso de nenhum cenario selecionado
    MOV R0, BACKGROUND_HOME     ; cenario de fundo do home
    MOV [BACKGROUND], R0        ; seleciona o cenario de fundo

    MOV R0, 0
    MOV [DISPLAYS], R0          ; setup inicial do display

; executar processos
    CALL controlo
    CALL teclado
    CALL energia
    CALL rover
    MOV R0, [lock_main]

; **********************************************************************
; Processo
;
; controlo - Processo que trata das teclas de comecar, pausar ou continuar
; e terminar o jogo.
;
; **********************************************************************
PROCESS sp_controlo
controlo:
    MOV R0, [lock_controlo]     ; ler o LOCK
    MOV R1, [estado]            ; ler o estado do jogo
    CMP R1, HOME                ; estamos no home screen?
    JZ home_prov
    JMP controlo
home_prov:
    ; premir c para comecar
    MOV R1, TSTART
    CMP R0, R1
    JZ comecar_jogo
    JMP controlo
comecar_jogo:
; prepara o inicio do jogo
    MOV R0, BACKGROUND_JOGO     ; cenario de fundo do jogo
    MOV [BACKGROUND], R0        ; seleciona o cenario de fundo

    MOV R0, JOGO                ; novo estado
    MOV [estado], R0            ; atualizar o estado do jogo
    MOV R1, MAX_ENERGIA         ; energia inicial
    CALL hex_p_dec_representacao
    MOV [DISPLAYS], R0          ; escreve a energia nos displays

    ; nave
    MOV R0, def_rover
    CALL desenha_objeto         ; desenhar nave

    ; inimigo
    MOV R0, def_inimigo
    CALL desenha_objeto         ; desenhar inimigo
    JMP controlo

; **********************************************************************
; Processo
;
; teclado - Processo que trata de detetar cliques no teclado
;
; **********************************************************************
PROCESS sp_teclado
teclado:
    MOV R2, MASCARA     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV R3, TEC_LIN     ; endereco do periferico de saida
    MOV R4, TEC_COL     ; endereco do periferico de entrada
espera_tecla:
; espera uma tecla ser premida e executa a funcao correspondente
;sem argumentos
    MOV  R5, LINHA_TEST ; comecar por testar a linha 4
loop_espera:
    WAIT                ; loop possivelmente infinito, utiliza se a diretiva WAIT para otimizar a utilizacao de recursos
    SHR R5, 1           ; shift right
    CMP R5, 0           ; verificar se estamos a testar uma linha valida
    JZ  espera_tecla    ; reinicializar o valor da linha e recomecar o ciclo caso linha seja invalida
    MOVB [R3], R5       ; escrever no periferico de saida (linhas)
    MOVB R0, [R4]       ; ler do periferico de entrada (colunas)
    AND R0, R2          ; elimina bits para além dos bits 0-3
    CMP R0, 0           ; ha tecla premida?
    JZ  loop_espera     ; se nenhuma tecla premida, repete
    MOV R9, R5          ; guardar a linha
    SHL R5, 4           ; coloca linha no nibble high
    OR  R5, R0          ; junta coluna (nibble low)
    MOV R0, [estado]    ; ler estado
    CMP R0, HOME        ; estamos no home screen?
    JZ home
    CMP R0, JOGO        ; estamos a jogar o jogo?
    JZ jogo
home:
    ; premir c para comecar
    MOV R0, TSTART
    CMP R5, R0
    JZ unlock_controlo
    JMP espera_tecla
jogo:
    ; caso subtrai_energia
    MOV R0, TSUB        ; agora R0 tem as coordenadas da tecla que subtrai a energia
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, -1          ; -1 porque queremos que muda_energia subtraia
    JZ unlock_energia   ; efetuar a operacao caso tenha sido pressionada

    ; caso adiciona_energia
    MOV R0, TADD        ; agora R0 tem as coordenadas da tecla que adiciona a energia
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, 2           ; 2 porque queremos que muda_energia adicione 10 (2*5)
    JZ unlock_energia   ; efetuar a operacao caso tenha sido pressionada

    ; caso move para esquerda
    MOV R0, TMOVESQ     ; agora R0 tem as coordenadas da tecla que move a nave para a esquerda
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, -1          ; prepara argumento para move_nave (-1 para esquerda)
    JZ unlock_rover     ; efetuar a operacao caso tenha sido pressionada

    ; caso move para direita
    MOV R0, TMOVDIR     ; agora R0 tem as coordenadas da tecla que move a nave para a direita
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, 1           ; prepara argumento para move_nave (1 para direita)
    JZ unlock_rover     ; efetuar a operacao caso tenha sido pressionada

    ; caso move inimigo para baixo
    MOV R0, TMOVINIM
    CMP R5, R0
    MOV R0, def_inimigo
    MOV R1, 2           ; prepara argumento para move_nave (2 para baixo)
    JZ unlock_inimigo

    JMP espera_tecla
largou:                 ; neste ciclo espera-se ate largar a tecla
    YIELD               ; loop possivelmente infinito
    MOVB [R3], R9       ; escrever no periferico de saída (linhas)
    MOVB R0, [R4]       ; ler do periferico de entrada (colunas)
    AND  R0, R5         ; elimina bits para além dos bits 0-3
    CMP R0, 0           ; ha tecla premida?
    JNZ largou          ; se ainda houver uma tecla premida repete o loop
    JMP espera_tecla    ; volta ao da funcao
delay:
; esta rotina e usada para controlar
; a velocidade de cliques continuos
;nao recebe argumentos
    PUSH R0
    MOV R0, DELAY
ciclo_delay:
    SUB R0, 1
    JNZ ciclo_delay
    POP R0
    RET
unlock_controlo:
    MOV [lock_controlo], R5
    JMP largou
unlock_energia:
    MOV [lock_energia], R0
    JMP largou
unlock_rover:
    MOV [lock_rover], R0
    YIELD
    CALL delay
    JMP espera_tecla
unlock_inimigo:
; esta merda nao e unlock nenhum mas precisava de dar nome na tag
    CALL move_objeto
    JMP largou

; **********************************************************************
; Processo
;
; energia - Processo que trata da energia.
;
; **********************************************************************
PROCESS sp_energia
energia:
    MOV R1, MAX_ENERGIA         ; valor inicial da energia
ciclo_energia:
    MOV R0, [lock_energia]      ; ler o LOCK, contem o valor a adicionar ou multiplicar
    CALL muda_energia           ; alterar a energia em funcao do calor lido
    JMP ciclo_energia
muda_energia:
; muda o valor da energia no display
;argumentos:
; R0 -> -1 ou 2 consoante vamos subtrair ou adicionar energia
; R1 -> Valor atual da energia
    ADD R1, R0          ; subtrair ou aumentar energia
    MOV R3, MAX_ENERGIA
    CMP R1, R3          ; verificar se excede o maximo
    JLE verifica_negativo
    MOV R1, MAX_ENERGIA ; se exceder o maximo volta a ser o maximo
verifica_negativo:
    CMP R1, MIN_ENERGIA ; verificar se nao e menor que o minimo
    JGE fim_muda_energia
    MOV R1, MIN_ENERGIA
fim_muda_energia:
    CALL hex_p_dec_representacao
    MOV [DISPLAYS], R0  ; atualiza a energia nos displays
    RET

; **********************************************************************
; Processo
;
; energia - Processo que trata da energia.
;
; **********************************************************************
PROCESS sp_rover
rover:
    MOV R0, def_rover         ; tabela que define o rover
loop_rover:
    MOV R1, [lock_rover]      ; ler o LOCK, contem a direcao em que mexer o rover
    CALL move_objeto
    JMP loop_rover

; **********************************************************************
; * Rotinas
; **********************************************************************

hex_p_dec_representacao:
; muda o valor hexadecimal para a sua representacao em binario
;argumentos (registos):
; R1 -> numero hexadecimal original
;valor retornado
; R0 -> numero final na representacao correta
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    MOV R7, 0       ; inicializar numero de algarismos
    MOV R0, 00H     ; inicializar resultado
    MOV R6, 0AH     ; numero 10 para divisao
    MOV R2, R1      ; copiar o valor inicial
ciclo_hex_p_dec:
    ADD R7, 1       ; contar numero de algarismos
    MOV R3, R2      ; R3 = R2
    DIV R3, R6      ; R3 = R3/10
    MOV R4, R2      ; R4 = R2
    MOV R2, R3      ; R2 = R3
    MUL R3, R6      ; R3 = R3*10
    SUB R4, R3      ; R4 = R4 - R3
    SHR R0, 4       ; R0 << 4
    MOV R5, MASCARA
    AND R4, R5      ; R4 & 000F
    SHL R4, 8       ; R4 << 8
    OR R0, R4       ; R0 = R0 | R4
    CMP R2, 0       ; verificar se chegou ao fim
    JNZ ciclo_hex_p_dec
    CMP R7, 3       ; verificar se ocupa os 3 digitos do display (se nao deu temos de dar SHR)
    JZ fim_hex_p_dec
    MOV R8, 3
    SUB R8, R7
    MOV R7, 4
    MUL R8, R7      ; R8 = 4*(numero de digitos)
ciclo_hex_p_dec_shr:
    SHR R0, 1       ; SHR R8 numero de vezes
    SUB R8, 1
    CMP R8, 0
    JNZ ciclo_hex_p_dec_shr
fim_hex_p_dec:
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    RET

move_objeto:
; move a objeto para a esquerda ou direita
;argumentos:
; R0 -> endereco da tabela que define os pixeis do objeto
; R1 -> direcao (1 = direita, -1 = esquerda, -2 = cima, 2 = baixo)
    PUSH R2
    PUSH R3
    ; verificar para que lado se vai mover
    CMP R1, 1
    JZ verificacao_direita
    CMP R1, 2
    JZ verificacao_baixo
verificacao_esquerda:
    MOV R2, [R0]        ; obtem posicao atual
    CMP R2, MIN_COLUNA  ; verifica se ja esta na posicao mais a esquerda
    JZ fim_move_objeto
    JMP move_x
verificacao_direita:
    ; verifica se ja esta no canto do ecra (direita)
    MOV R2, [R0]        ; obtem posicao atual
    MOV R3, [R0+4]      ; obtem largura da nave
    ADD R2, R3          ; adiciona largura
    MOV R3, MAX_COLUNA  ; largura do ecra
    CMP R2, R3          ; verifica se ja esta na posicao mais a direita
    JGT fim_move_objeto ; se ja estiver nao se mexe
    JMP move_x
verificacao_baixo:
; meter aqui codigo que remove da tabela de objetos caso objeto avance pa fora
    MOV R2, [R0+2]      ; obtem posicao atual
    MOV R3, MAX_LINHA   ; limite maximo da linha
    CMP R2, R3          ; ver se nao execedemos o limite
    JLT move_y          ; se nao excedemos continuamos normalmente
    JZ apagar_objeto    ; se estivermos na ultima linha so queremos apagar o objeto
    JMP fim_move_objeto
apagar_objeto:
    CALL apaga_objeto
    JMP fim_move_objeto
move_x:
    MOV R2, [R0]      ; obtem posicao atual
    CALL apaga_objeto   ; apagar objeto
    ADD R2, R1          ; obter a nova coordenada
    MOV [R0], R2        ; atualiza posicao objeto
    CALL desenha_objeto ; desenhar objeto
    JMP fim_move_objeto ; terminar
move_y:
    MOV R2, [R0+2]      ; obtem posicao atual
    SHRA R1, 1          ; dividir por 2 o argumento preservando o sinal
    CALL apaga_objeto   ; apagar objeto
    ADD R2, R1          ; obter a nova coordenada
    MOV [R0+2], R2      ; atualiza posicao objeto
    CALL desenha_objeto ; desenhar objeto
    MOV R2, TIRO        ; som a reproduzir
    MOV [PLAY_SOM], R2
fim_move_objeto:
    POP R3
    POP R2
    RET

desenha_objeto:
; desenha um objeto
;argumentos:
; R0 -> endereco da tabela que define os pixeis do objeto
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
    ADD R4, R2
    SUB R4, 1           ; linha final
    CALL atualiza_linha ; verificar se a linha final nao excede os limites do ecra
    MOV R7, 8
    ADD R7, R0          ; endereco da cor do primeiro pixel
    MOV R5, R1          ; copia das coordenadas iniciais da coluna
desenha_colunas:        ; desenha os pixels do boneco a partir da tabela
    MOV R6, [R7]        ; obtem a cor do proximo pixel
    MOV [SEL_COLUNA], R1; seleciona a coluna
    MOV [SEL_LINHA], R2 ; seleciona a linha
    MOV [SEL_PIXEL], R6 ; altera a cor do pixel na linha e coluna selecionadas
    ADD R7, 2           ; endereco da cor do proximo pixel
    ADD R1, 1           ; proxima coluna
    CMP R1, R3          ; verificar se ja tratamos da largura toda
    JNZ desenha_colunas ; continua ate percorrer toda a largura do objeto
    ADD R2, 1           ; proxima linha
    MOV R1, R5          ; reiniciar as colunas
    CMP R2, R4          ; verificar se ja tratamos da altura toda
    JLE desenha_colunas ; continuar ate tratar da altura toda
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

apaga_objeto:
; apaga um objeto
;argumentos:
; R0 -> endereco da tabela que define os pixeis do objeto
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    MOV R3, [R0 + 4]    ; obtem a largura do objeto
    MOV R4, [R0 + 6]    ; obtem a altura do objeto
    MOV R1, [R0]        ; coluna inicial
    MOV R2, [R0+2]      ; linha inicial
    ADD R3, R1          ; coluna final
    ADD R4, R2
    SUB R4, 1           ; linha final
    CALL atualiza_linha ; verificar se a linha final nao excede os limites do ecra
    MOV R5, R1          ; copia das coordenadas iniciais da coluna
    MOV R6, 0           ; escolhe cor 0 (apagar)
apaga_colunas:          ; desenha os pixels do boneco a partir da tabela
    MOV [SEL_COLUNA], R1; seleciona a coluna
    MOV [SEL_LINHA], R2 ; seleciona a linha
    MOV [SEL_PIXEL], R6 ; apaga o pixel na linha e coluna selecionadas
    ADD R1, 1           ; proxima coluna
    CMP R1, R3          ; verificar se ja tratamos da largura toda
    JNZ apaga_colunas   ; continua ate percorrer toda a largura do objeto
    ADD R2, 1           ; proxima linha
    MOV R1, R5          ; reiniciar as colunas
    CMP R2, R4          ; verificar se ja tratamos da altura toda
    JLE apaga_colunas   ; continuar ate tratar da altura toda
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    RET

atualiza_linha:
; atualiza, se necessario, a linha, para nao exceder os limites do ecra
;argumentos:
; R4 -> linha a atualizar
    PUSH R0
    MOV R0, MAX_LINHA
    CMP R4, R0              ; verificar se excedemos a linha
    JLE fim_atualiza_linha  ; se nao excedemos nao ha nada a fazer
    MOV R4, MAX_LINHA       ; se excedemos so podemos desenhar o objeto ate a linha final
fim_atualiza_linha:
    POP R0
    RET
