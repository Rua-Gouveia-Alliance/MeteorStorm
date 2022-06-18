; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS    EQU 0A000H  ; endereco dos displays de 7 segmentos (periferico POUT-1)
TEC_LIN     EQU 0C000H  ; endereco das linhas do teclado (periferico POUT-2)
TEC_COL     EQU 0E000H  ; endereco das colunas do teclado (periferico PIN)
LINHA_TEST  EQU 16      ; linha a testar (comecamos na 4a linha, mas por causa do shift right inicial inicializamos ao dobro)
MASCARA_MSD EQU 0FH     ; para remover os 4 bits de maior peso, ao ler as colunas do teclado
TSTART      EQU 10000001b ; tecla para comecar o jogo
TPAUSA      EQU 00011000b ; tecla para pausar o jogo
TTERMINA    EQU 00010100b ; tecla para terminar o jogo
TMOVESQ     EQU 10000001b ; tecla para mover nave para a esquerda
TMOVDIR     EQU 10000100b ; tecla para mover nave para a direita
TMISSIL     EQU 01000010b ; tecla para disparar um missil

MAX_ENERGIA EQU 064H    ; valor inicial da energia e maximo
MIN_ENERGIA EQU 0       ; valor minimo da energia
FENERGIA    EQU 05H     ; maximo divisor comum do valor de energia a subtrair e adicionar

MORTO       EQU -3      ; estado em que o jogo esta (jogador morto)
HOME        EQU 0       ; estado em que o jogo esta (home screen)
JOGO        EQU 1       ; estado em que o jogo esta (a ser jogado)
PAUSADO     EQU 2       ; estado em que o jogo esta (pausado)
TERMINADO   EQU 3       ; estado em que o jogo esta (terminado)

BG_JOGO     EQU 0       ; imagem de fundo do jogo
BG_HOME     EQU 1       ; imagem de fundo do home screen
BG_ENERGIA  EQU 2       ; imagem de fundo de quando se morre por falta de energia
BG_COLISAO  EQU 3       ; imagem de fundo de quando se morre por colisao
BG_PAUSA    EQU 4       ; imagem de fundo do menu de pausa
BG_TERMINA  EQU 5       ; imagem de fundo do menu terminado

DEL_ECRA    EQU 6000H   ; endereco do comando para apagar o ecra especificado
DEL_ECRAS   EQU 6002H   ; endereco do comando para apagar todos os ecras
SEL_ECRA    EQU 6004H   ; endereco do comando para selecionar o ecra onde vamos escrever
SEL_LINHA   EQU 600AH   ; endereco do comando para definir a linha
SEL_COLUNA  EQU 600CH   ; endereco do comando para definir a coluna
SEL_PIXEL   EQU 6012H   ; endereco do comando para escrever um pixel
DEL_AVISO   EQU 6040H   ; endereco do comando para apagar o aviso de nenhum cenario selecionado
BACKGROUND  EQU 6042H   ; endereco do comando para selecionar uma imagem de fundo
MOSTRAR     EQU 6006H   ; endereco do comando para mostrar o ecra selecionado
ESCONDER    EQU 6008H   ; endereco do comando para esconder o ecra selecionado
PLAY_SOM    EQU 605AH   ; endereco do comando para reproduzir um som

ECRA_PRINCIPAL   EQU 0  ; indice do ecra principal
ECRA_MISSIL EQU 4       ; indice do ecra do missil

STIRO        EQU 0       ; som do tiro
SEXPLOSAO    EQU 1       ; som da explosao
SENERGIA     EQU 2       ; som da energia

MIN_COLUNA  EQU 0       ; numero da coluna mais a esquerda
MAX_COLUNA  EQU 63      ; numero da coluna mais a direita
MAX_COLUNA_OBJ  EQU 58  ; numero da coluna mais a direita que um objeto pode ocupar (coluna maxima menos a largura maxima)
MIN_LINHA   EQU 0       ; numero da linha mais acima
MAX_LINHA   EQU 31      ; numero da linha mais abaixo

DELAY       EQU 2000H   ; atraso para limitar a velocidade de movimento da nave

DIREITA     EQU 1       ; valor a adicionar para ir para a direita
ESQUERDA    EQU -1      ; valor a adicionar para ir para a esquerda
DISPARAR    EQU 2       ; sinal para o processo do rover, disparar um missil

COMECAR     EQU 0       ; sinal para o processo de controlo, comecar jogo
MORTE_ENG   EQU 1       ; sinal para o processo de controlo, morte por falta de energia
MORTE_COL   EQU 2       ; sinal para o processo de controlo, morte por colisao
REINICIAR   EQU 3       ; sinal para o processo de controlo, reiniciar o jogo
PAUSAR      EQU 4       ; sinal para o processo de controlo, pausar o jogo
DESPAUSAR   EQU 5       ; sinal para o processo de controlo, despausar o jogo
TERMINAR    EQU 6       ; sinal para o processo de controlo, terminar o jogo

NAVE_X      EQU 30      ; coluna da nave
NAVE_Y      EQU 28      ; linha da nave
NAVE_LX     EQU 5       ; largura da nave
NAVE_LY     EQU 4       ; altura da nave

OBJETO_Y    EQU 0       ; linha do inimigo
OBJETO_PX   EQU 5       ; largura do inimigo/meteoro bom perto
OBJETO_PY   EQU 5       ; altura do inimigo/meteoro bom perto
OBJETO_MX   EQU 4       ; largura do inimigo/meteoro bom a distancia media
OBJETO_MY   EQU 4       ; altura do inimigo/meteoro bom a distancia media
OBJETO_LX   EQU 3       ; largura do inimigo/meteoro bom longe
OBJETO_LY   EQU 3       ; altura do inimigo/meteoro bom longe
OBJETO_DX   EQU 2       ; largura do inimigo/meteoro distante
OBJETO_DY   EQU 2       ; altura do inimigo/meteoro distante
OBJETO_MDX  EQU 1       ; largura do inimigo/meteoro muito distante
OBJETO_MDY  EQU 1       ; altura do inimigo/meteoro muito distante
DISTANTE    EQU 3       ; coordenada a partir da qual se considera distante
LONGE       EQU 6       ; coordenada a partir da qual se considera longe
MEDIO       EQU 9       ; coordenada a partir da qual se considera distancia media
PERTO       EQU 12      ; coordenada a partir da qual se considera perto

MISSIL_LX   EQU 1
MISSIL_LY   EQU 1

METEORO_BOM EQU 0       ; codigo para identificar um meteoro bom generico
INIMIGO     EQU 1       ; codigo para identificar um inimigo generico
INIMIGO1    EQU 2       ; codigo para gerar um inimigo (processo objetos)
INIMIGO2    EQU 3       ; codigo para gerar um inimigo (processo objetos)
INIMIGO3    EQU 4       ; codigo para gerar um inimigo (processo objetos)
METEORO_BOM1 EQU 5      ; codigo para gerar um meteoro bom (processo objetos)
METEORO_BOM2 EQU 6      ; codigo para gerar um meteoro bom (processo objetos)

NUM_OBJS    EQU 4       ; num de objetos (meteoros bons e inimigos) no jogo

OFFSET      EQU 15      ; numero a multiplicar pela instancia do objeto para haver sempre algum espacamento entre as coordenadas aleatorias geradas

RED         EQU 0FF00H  ; cor vermelho em ARGB
GREY        EQU 0FFFFH  ; cor cinzento em ARGB
BLUE        EQU 0F0FFH  ; cor azul em ARGB
GREEN       EQU 0F0F0H  ; cor verde em ARGB
YELLOW      EQU 0FFF0H  ; cor amarelo em ARGB
PURPLE      EQU 0FA3AH  ; cor roxa em ARGB

TRUE        EQU 1       ; valor boleano
FALSE       EQU 0       ; valor boleano

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

    STACK 100H          ; espaco reservado para a stack do processo que trata dos misseis
sp_missil:

    STACK 100H          ; espaco reservado para a stack do processo que trata da animacao
sp_animacao:

    STACK 100H          ; espaco reservado para a stack do processo que trata dos objetos (meteoros bons e inimigos), indice 0
sp_objeto_0:

    STACK 100H          ; espaco reservado para a stack do processo que trata dos objetos (meteoros bons e inimigos), indice 1
sp_objeto_1:

    STACK 100H          ; espaco reservado para a stack do processo que trata dos objetos (meteoros bons e inimigos), indice 2
sp_objeto_2:

    STACK 100H          ; espaco reservado para a stack do processo que trata dos objetos (meteoros bons e inimigos), indice 3
sp_objeto_3:

sp_objetos:
; espaco reservado para as stacks das varias instancias do processo que trata dos objetos (meteoros bons e inimigos)
    WORD sp_objeto_0
    WORD sp_objeto_1
    WORD sp_objeto_2
    WORD sp_objeto_3

lock_controlo:          ; variavel para controlar o processo controlo
    LOCK    0

lock_energia:           ; variavel para controlar o processo energia
    LOCK    0

lock_rover:             ; variavel para controlar o processo rover
    LOCK    0

lock_objeto:            ; variaveis para controlar o processo objeto
    LOCK    0           ; objeto 0
    LOCK    0           ; objeto 1
    LOCK    0           ; objeto 2
    LOCK    0           ; objeto 3

lock_gere_objetos:      ; variavel para controlar o processo gere_objetos
    LOCK    0

lock_missil:            ; variavel para controlar o processo missil
    LOCK    0

lock_animacao:          ; variavel para controlar o processo animacao
    LOCK    0

estado:
    WORD HOME           ; estado do jogo

tab_int:                ; tabela de interrupcoes
    WORD int_meteoros
    WORD int_missil
    WORD int_energia

def_rover:              ; tabela que define o rover (largura, altura e cor dos pixeis)
    WORD    NAVE_LX
    WORD    NAVE_LY
    WORD    0, 0, YELLOW, 0, 0
    WORD    YELLOW, 0, YELLOW, 0, YELLOW
    WORD    YELLOW, YELLOW, YELLOW, YELLOW, YELLOW
    WORD    0, YELLOW, 0, YELLOW, 0

ROVER_X:                ; coordenada X do rover
    WORD    NAVE_X

ROVER_Y:                ; coordenada Y do rover
    WORD    NAVE_Y

MISSIL_X:               ; coordenada X do missil
    WORD    0

MISSIL_Y:               ; coordenada Y do missil
    WORD    0

MISSIL_DISPARADO:
    WORD    FALSE       ; TRUE se existe um missil no ecra, FALSE caso contrario

def_missil:
    WORD    MISSIL_LX
    WORD    MISSIL_LY
    WORD    PURPLE

escolhe_objeto:
; tabela que tem meteoros bons e inimigos para ajudar a determinar de forma pseudo aleatoria
; qual dos dois e gerado
    WORD    METEORO_BOM1
    WORD    INIMIGO1
    WORD    INIMIGO2
    WORD    INIMIGO3
    WORD    METEORO_BOM2
    WORD    INIMIGO1
    WORD    INIMIGO2
    WORD    INIMIGO3

def_muito_distante:     ; tabela que define o inimigo/metero bom muito distante (largura, altura e cor dos pixeis)
    WORD    OBJETO_MDX
    WORD    OBJETO_MDY
    WORD    GREY

def_distante:           ; tabela que define o inimigo/metero bom distante (largura, altura e cor dos pixeis)
    WORD    OBJETO_DX
    WORD    OBJETO_DY
    WORD    GREY, GREY
    WORD    GREY, GREY

def_inimigo1_perto:     ; tabela que define o inimigo perto (largura, altura e cor dos pixeis)
    WORD    OBJETO_PX
    WORD    OBJETO_PY
    WORD    RED, 0, 0, 0, RED
    WORD    RED, 0, RED, 0, RED
    WORD    0, RED, RED, RED, 0
    WORD    RED, 0, RED, 0, RED
    WORD    RED, 0, 0, 0, RED

def_inimigo1_medio:     ; tabela que define o inimigo a distancia media (largura, altura e cor dos pixeis)
    WORD    OBJETO_MX
    WORD    OBJETO_MY
    WORD    RED, 0, 0, RED
    WORD    RED, 0, 0, RED
    WORD    0, RED, RED, 0
    WORD    RED, 0, 0, RED

def_inimigo1_longe:     ; tabela que define o inimigo longe (largura, altura e cor dos pixeis)
    WORD    OBJETO_LX
    WORD    OBJETO_LY
    WORD    RED, 0, RED
    WORD    0, RED, 0
    WORD    RED, 0, RED

distancias_inimigo1:
    WORD def_inimigo1_perto
    WORD def_inimigo1_medio
    WORD def_inimigo1_longe
    WORD def_distante

def_inimigo2_perto:     ; tabela que define o inimigo perto (largura, altura e cor dos pixeis)
    WORD    OBJETO_PX
    WORD    OBJETO_PY
    WORD    RED, 0, 0, 0, RED
    WORD    0, RED, 0, RED, 0
    WORD    0, 0, RED, 0, 0
    WORD    0, RED, 0, RED, 0
    WORD    RED, 0, 0, 0, RED

def_inimigo2_medio:     ; tabela que define o inimigo a distancia media (largura, altura e cor dos pixeis)
    WORD    OBJETO_MX
    WORD    OBJETO_MY
    WORD    RED, 0, 0, RED
    WORD    0, RED, RED, 0
    WORD    0, RED, RED, 0
    WORD    RED, 0, 0, RED

def_inimigo2_longe:     ; tabela que define o inimigo longe (largura, altura e cor dos pixeis)
    WORD    OBJETO_LX
    WORD    OBJETO_LY
    WORD    0, RED, 0
    WORD    RED, 0, RED
    WORD    0, RED, 0

distancias_inimigo2:
    WORD def_inimigo2_perto
    WORD def_inimigo2_medio
    WORD def_inimigo2_longe
    WORD def_distante

def_inimigo3_perto:     ; tabela que define o inimigo perto (largura, altura e cor dos pixeis)
    WORD    OBJETO_PX
    WORD    OBJETO_PY
    WORD    0, 0, RED, 0, 0
    WORD    RED, 0, RED, 0, RED
    WORD    RED, RED, RED, RED, RED
    WORD    RED, 0, RED, 0, RED
    WORD    0, 0, RED, 0, 0

def_inimigo3_medio:     ; tabela que define o inimigo a distancia media (largura, altura e cor dos pixeis)
    WORD    OBJETO_MX
    WORD    OBJETO_MY
    WORD    RED, 0, 0, RED
    WORD    RED, RED, RED, RED
    WORD    RED, 0, 0, RED
    WORD    RED, 0, 0, RED

def_inimigo3_longe:     ; tabela que define o inimigo longe (largura, altura e cor dos pixeis)
    WORD    OBJETO_LX
    WORD    OBJETO_LY
    WORD    RED, RED, 0
    WORD    RED, 0, RED
    WORD    0, RED, RED

distancias_inimigo3:
    WORD def_inimigo3_perto
    WORD def_inimigo3_medio
    WORD def_inimigo3_longe
    WORD def_distante

def_meteoro1_perto:      ; tabela que define o meteoro bom perto (largura, altura e cor dos pixeis)
    WORD    OBJETO_PX
    WORD    OBJETO_PY
    WORD    0, GREEN, GREEN, GREEN, 0
    WORD    GREEN, GREEN, GREEN, GREEN, GREEN
    WORD    GREEN, GREEN, GREEN, GREEN, GREEN
    WORD    GREEN, GREEN, GREEN, GREEN, GREEN
    WORD    0, GREEN, GREEN, GREEN, 0

def_meteoro1_medio:      ; tabela que define o meteoro bom a distancia media (largura, altura e cor dos pixeis)
    WORD    OBJETO_MX
    WORD    OBJETO_MY
    WORD    0, GREEN, GREEN, 0
    WORD    GREEN, GREEN, GREEN, GREEN
    WORD    GREEN, GREEN, GREEN, GREEN
    WORD    0, GREEN, GREEN, 0

def_meteoro1_longe:      ; tabela que define o meteoro bom longe (largura, altura e cor dos pixeis)
    WORD    OBJETO_LX
    WORD    OBJETO_LY
    WORD    0, GREEN, 0
    WORD    GREEN, GREEN, GREEN
    WORD    0, GREEN, 0

distancias_meteoro1:
    WORD def_meteoro1_perto
    WORD def_meteoro1_medio
    WORD def_meteoro1_longe
    WORD def_distante

def_meteoro2_perto:      ; tabela que define o meteoro bom perto (largura, altura e cor dos pixeis)
    WORD    OBJETO_PX
    WORD    OBJETO_PY
    WORD    0, 0, GREEN, 0, 0
    WORD    0, GREEN, 0, 0, 0
    WORD    GREEN, GREEN, GREEN, GREEN, GREEN
    WORD    0, 0, 0, GREEN, 0
    WORD    0, 0, GREEN, 0, 0

def_meteoro2_medio:      ; tabela que define o meteoro bom a distancia media (largura, altura e cor dos pixeis)
    WORD    OBJETO_MX
    WORD    OBJETO_MY
    WORD    0, GREEN, 0, 0
    WORD    GREEN, GREEN, GREEN, GREEN
    WORD    0, 0, GREEN, 0
    WORD    0, GREEN, 0, 0

def_meteoro2_longe:      ; tabela que define o meteoro bom longe (largura, altura e cor dos pixeis)
    WORD    OBJETO_LX
    WORD    OBJETO_LY
    WORD    0, 0, GREEN
    WORD    GREEN, GREEN, GREEN
    WORD    GREEN, 0, 0

distancias_meteoro2:
    WORD def_meteoro2_perto
    WORD def_meteoro2_medio
    WORD def_meteoro2_longe
    WORD def_distante

def_frame_1:            ; tabela que define o primeiro frame da animacao de explosao (largura, altura e cor dos pixeis)
    WORD    OBJETO_PX
    WORD    OBJETO_PY
    WORD    0, 0, 0, 0, 0
    WORD    0, 0, BLUE, 0, 0
    WORD    0, BLUE, 0, BLUE, 0
    WORD    0, 0, BLUE, 0, 0
    WORD    0, 0, 0, 0, 0

def_frame_2:            ; tabela que define o segundo frame da animacao de explosao (largura, altura e cor dos pixeis)
    WORD    OBJETO_PX
    WORD    OBJETO_PY
    WORD    0, BLUE, 0, BLUE, 0
    WORD    BLUE, 0, BLUE, 0, BLUE
    WORD    0, BLUE, 0, BLUE, 0
    WORD    BLUE, 0, BLUE, 0, BLUE
    WORD    0, BLUE, 0, BLUE, 0

def_frame_3:            ; tabela que define o terceiro frame da animacao de explosao (largura, altura e cor dos pixeis)
    WORD    OBJETO_PX
    WORD    OBJETO_PY
    WORD    BLUE, 0, BLUE, 0, BLUE
    WORD    0, BLUE, 0, BLUE, 0
    WORD    BLUE, 0, BLUE, 0, BLUE
    WORD    0, BLUE, 0, BLUE, 0
    WORD    BLUE, 0, BLUE, 0, BLUE

frames:
    WORD def_frame_1
    WORD def_frame_2
    WORD def_frame_3

; **********************************************************************
; * Codigo
; **********************************************************************
PLACE      0
main:
; inicializacoes
    MOV SP, sp_main             ; inicializar o stack pointer com o endereco 1200H
    MOV BTE, tab_int            ; inicializar BTE (registo de Base da Tabela de Exceções)
; setup inicial do ecra
    MOV [DEL_ECRAS], R0
    MOV [DEL_AVISO], R0         ; apaga o aviso de nenhum cenario selecionado
    MOV R0, BG_HOME             ; cenario de fundo do home
    MOV [BACKGROUND], R0        ; seleciona o cenario de fundo

    MOV R0, 0
    MOV [DISPLAYS], R0          ; setup inicial do display
; permitir interrupcoes
    EI0                         ; permitir interrupcoes 0
    EI1                         ; permitir interrupcoes 1
    EI2                         ; permitir interrupcoes 2
    EI                          ; permitir interrupcoes (geral)
; executar processos
    CALL controlo
    CALL teclado
; o resto do programa principal e tambem um processo, que gere os objetos
gere_objetos:
    MOV R10, [lock_gere_objetos]
    CALL objeto
    JMP gere_objetos

; **********************************************************************
; Processo
;
; controlo - Processo que trata das teclas de comecar, pausar ou continuar
; e terminar o jogo.
;
; **********************************************************************
PROCESS sp_controlo
controlo:
    MOV SP, sp_controlo         ; re-inicializar o stack pointer
loop_controlo:
    MOV R0, [lock_controlo]     ; ler o LOCK
    MOV R1, COMECAR
    CMP R0, R1
    JZ comecar_jogo
    MOV R1, REINICIAR
    CMP R0, R1
    JZ reiniciar_jogo
    MOV R1, PAUSAR
    CMP R0, R1
    JZ pausar_jogo
    MOV R1, DESPAUSAR
    CMP R0, R1
    JZ despausar_jogo
    MOV R1, MORTE_ENG
    CMP R0, R1
    JZ morte_falta_energia
    MOV R1, MORTE_COL
    CMP R0, R1
    MOV R2, BG_COLISAO          ; visto que terminar o jogo e equivalente a morte por colisao, apenas selecionamos o bg
    JZ morte_colisao
    MOV R1, TERMINAR
    CMP R0, R1
    MOV R2, BG_TERMINA          ; idem
    JZ morte_colisao
    JMP controlo
comecar_jogo:
; prepara o inicio do jogo
    MOV R0, ECRA_PRINCIPAL      ; garantir que estamos a trabalhar com o ecra certo
    MOV [SEL_ECRA], R0          ; atualizar o ecra que esta selecionado
; criar os objetos
    MOV R0, NUM_OBJS
criar_objetos:
    SUB R0, 1
    MOV [lock_gere_objetos], R0 ; criar um objeto novo
    YIELD                       ; deixar o processo gere_objetos criar o objeto
    CMP R0, 0
    JNZ criar_objetos
reiniciar_jogo:
    MOV R0, ECRA_PRINCIPAL      ; garantir que estamos a trabalhar com o ecra certo
    MOV [SEL_ECRA], R0          ; atualizar o ecra que esta selecionado
    MOV R0, BG_JOGO             ; cenario de fundo do jogo
    MOV [BACKGROUND], R0        ; seleciona o cenario de fundo
    MOV R0, JOGO                ; novo estado
    MOV [estado], R0            ; atualizar o estado do jogo

    CALL energia                ; iniciar a energia
    CALL rover                  ; iniciar o rover

    JMP loop_controlo
pausar_jogo:
    MOV R0, 0
pausar_jogo_ciclo:
    MOV [SEL_ECRA], R0          ; atualizar o ecra que esta selecionado
    MOV [ESCONDER], R0
    ADD R0, 1
    CMP R0, 5
    JNZ pausar_jogo_ciclo

    MOV R0, BG_PAUSA            ; cenario de fundo do menu de pausa
    MOV [BACKGROUND], R0        ; atualizar cenario de fundo

    MOV R0, PAUSADO
    MOV [estado], R0            ; atualizar estado

    JMP loop_controlo
despausar_jogo:
    MOV R0, 0
despausar_jogo_ciclo:
    MOV [SEL_ECRA], R0          ; atualizar o ecra que esta selecionado
    MOV [MOSTRAR], R0
    ADD R0, 1
    CMP R0, 5
    JNZ despausar_jogo_ciclo

    MOV R0, BG_JOGO             ; cenario de fundo da morte por falta de energia
    MOV [BACKGROUND], R0        ; atualizar cenario de fundo

    MOV R0, JOGO
    MOV [estado], R0            ; atualizar estado

    JMP loop_controlo
morte_falta_energia:
    MOV [DEL_ECRAS], R0         ; apagar todos os desenhos no ecra
    MOV R0, ECRA_PRINCIPAL      ; garantir que estamos a trabalhar com o ecra certo
    MOV [SEL_ECRA], R0          ; atualizar o ecra que esta selecionado
    MOV R0, BG_ENERGIA          ; cenario de fundo da morte por falta de energia
    MOV [BACKGROUND], R0        ; atualizar cenario de fundo

    MOV R0, MORTO
    MOV [estado], R0            ; atualizar estado

    MOV [lock_rover], R0        ; eliminar o rover
    MOV [lock_missil], R0       ; sinalizar o missil de que o rover morreu

    JMP eliminar_objetos
morte_colisao:
    MOV [DEL_ECRAS], R0         ; apagar todos os desenhos no ecra
    MOV R0, ECRA_PRINCIPAL      ; garantir que estamos a trabalhar com o ecra certo
    MOV [SEL_ECRA], R0          ; atualizar o ecra que esta selecionado
    MOV [BACKGROUND], R2        ; atualizar cenario de fundo

    MOV R0, MORTO
    MOV [estado], R0            ; atualizar estado

    MOV [lock_rover], R0        ; eliminar o rover
    MOV [lock_energia], R0      ; sinalizar a energia de que o rover morreu
    MOV [lock_missil], R0       ; sinalizar o missil de que o rover morreu

eliminar_objetos:
    MOV R2, lock_objeto
    MOV R1, NUM_OBJS
    SHL R1, 1
eliminar_objetos_loop:
    SUB R1, 2
    MOV [R2+R1], R0             ; eliminar o objeto
    CMP R1, 0
    JNZ eliminar_objetos_loop

    JMP controlo

; **********************************************************************
; Processo
;
; teclado - Processo que trata de detetar cliques no teclado
;
; **********************************************************************
PROCESS sp_teclado
teclado:
    MOV SP, sp_teclado  ; re-inicializar o stack pointer
    MOV R2, MASCARA_MSD ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
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
    AND R0, R2          ; elimina bits para alem dos bits 0-3
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
    CMP R0, PAUSADO     ; estamos com o jogo em pausa?
    JZ pausado
    CMP R0, MORTO       ; estamos mortos?
    JZ morto
home:
    ; premir c para comecar
    MOV R0, TSTART      ; agora R0 tem as coordenadas da tecla que comeca
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, COMECAR     ; prepara argumento para o processo controlo
    JZ unlock_controlo  ; efetuar a operacao caso tenha sido pressionada
    JMP espera_tecla
morto:
    ; premir c para reiniciar o jogo
    MOV R0, TSTART      ; agora R0 tem as coordenadas da tecla que comeca
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, REINICIAR   ; prepara argumento para o processo controlo
    JZ unlock_controlo  ; efetuar a operacao caso tenha sido pressionada
    JMP espera_tecla
pausado:
    ; despausar
    MOV R0, TPAUSA      ; agora R0 tem as coordenadas da tecla que despausa
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, DESPAUSAR   ; prepara argumento para o processo controlo
    JZ unlock_controlo  ; efetuar a operacao caso tenha sido pressionada
    JMP espera_tecla
jogo:
    ; caso move para esquerda
    MOV R0, TMOVESQ     ; agora R0 tem as coordenadas da tecla que move o rover para a esquerda
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, ESQUERDA    ; prepara argumento para o processo rover
    JZ unlock_rover_mov ; efetuar a operacao caso tenha sido pressionada

    ; caso move para direita
    MOV R0, TMOVDIR     ; agora R0 tem as coordenadas da tecla que move o rover para a direita
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, DIREITA     ; prepara argumento para o processo rover
    JZ unlock_rover_mov ; efetuar a operacao caso tenha sido pressionada

    ; disparo do missil
    MOV R0, TMISSIL     ; agora R0 tem as coordenadas da tecla que dispara
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, DISPARAR    ; prepara argumento para o processo rover
    JZ unlock_rover_disparo ; efetuar a operacao caso tenha sido pressionada

    ; caso pausa o jogo
    MOV R0, TPAUSA      ; agora R0 tem as coordenadas da tecla que move o rover para a esquerda
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, PAUSAR      ; prepara argumento para o processo controlo
    JZ unlock_controlo  ; efetuar a operacao caso tenha sido pressionada

    ; caso termina o jogo
    MOV R0, TTERMINA    ; agora R0 tem as coordenadas da tecla que move o rover para a esquerda
    CMP R5, R0          ; verifica se carregamos nessa tecla
    MOV R0, TERMINAR    ; prepara argumento para o processo controlo
    JZ unlock_controlo  ; efetuar a operacao caso tenha sido pressionada

    JMP espera_tecla
largou:                 ; neste ciclo espera-se ate largar a tecla
    YIELD               ; ciclo possivelmente infinito
    MOVB [R3], R9       ; escrever no periferico de saída (linhas)
    MOVB R0, [R4]       ; ler do periferico de entrada (colunas)
    AND  R0, R5         ; elimina bits para além dos bits 0-3
    CMP R0, 0           ; ha tecla premida?
    JNZ largou          ; se ainda houver uma tecla premida repete o loop
    JMP espera_tecla    ; volta ao da funcao
unlock_controlo:
    MOV [lock_controlo], R0 ; passar os argumentos ao processo
    JMP largou
unlock_rover_disparo:
    MOV [lock_rover], R0    ; passar os argumentos ao processo
    JMP largou
unlock_rover_mov:
    MOV [lock_rover], R0    ; passar os argumentos ao processo
    CALL delay
    JMP espera_tecla

; **********************************************************************
; Processo
;
; energia - Processo que trata da energia.
;
; **********************************************************************
PROCESS sp_energia
energia:
    MOV SP, sp_energia          ; re-inicializar o stack pointer
    MOV R1, MAX_ENERGIA         ; valor inicial da energia
    CALL hex_p_dec_representacao
ciclo_energia:
    MOV [DISPLAYS], R0          ; atualizar o valor no ecra
    MOV R0, [lock_energia]      ; ler o LOCK, contem o valor a adicionar ou multiplicar, ou o sinal de que o rover morreu
    CMP R0, MORTO               ; o rover morreu?
    JZ elimina_energia
    JMP muda_energia            ; alterar a energia em funcao do calor lido
muda_energia:
; mudar o valor da energia
    MOV R2, FENERGIA
    MUL R0, R2
    ADD R1, R0          ; subtrair ou aumentar energia
    MOV R3, MAX_ENERGIA
    CMP R1, R3          ; verificar se excede o maximo
    JLE verifica_negativo
    MOV R1, MAX_ENERGIA ; se exceder o maximo volta a ser o maximo
verifica_negativo:
    CMP R1, MIN_ENERGIA ; verificar se nao e menor que o minimo
    JGT fim_muda_energia
    JMP morte_energia
fim_muda_energia:
    CALL hex_p_dec_representacao
    MOV [DISPLAYS], R0  ; atualiza a energia nos displays
    JMP ciclo_energia
morte_energia:
    MOV R1, 0
    CALL hex_p_dec_representacao
    MOV [DISPLAYS], R0  ; mostrar 0 de energia enquanto nao estamos a jogar o jogo
    MOV R0, MORTE_ENG
    MOV [lock_controlo], R0
elimina_energia:
    RET

; **********************************************************************
; Processo
;
; rover - Processo que trata do movimento do rover.
;
; **********************************************************************
PROCESS sp_rover
rover:
    MOV SP, sp_rover          ; re-inicializar o stack pointer
    MOV R0, def_rover         ; tabela que define o rover
    MOV R1, NAVE_X            ; coordenadas default
    MOV R2, NAVE_Y            ; coordenadas default
    MOV R4, ECRA_PRINCIPAL    ; garantir que estamos a trabalhar com o ecra certo
    MOV [SEL_ECRA], R4        ; atualizar o ecra que esta selecionado
    CALL desenha_objeto       ; desenhar o rover inicial no ecra
loop_rover:
    MOV [ROVER_X], R1         ; atualizar posicao do rover global
    MOV [ROVER_Y], R2
    MOV R3, [lock_rover]      ; ler o LOCK, contem a direcao em que mexer o rover ou se vamos disparar
    MOV R4, ECRA_PRINCIPAL    ; garantir que estamos a trabalhar com o ecra certo
    MOV [SEL_ECRA], R4        ; atualizar o ecra que esta selecionado
    CMP R3, MORTO             ; o rover morreu?
    JZ elimina_rover
    CMP R3, DISPARAR          ; vamos disparar?
    JZ check_missil
    CMP R3, DIREITA           ; vamos mexer para a direita?
    JZ move_direita
move_esquerda:
    CMP R1, MIN_COLUNA        ; verifica se ja esta na posicao mais a esquerda
    JZ loop_rover             ; se sim nao fazemos nada
    CALL move_x
    JMP loop_rover
move_direita:
    ; verifica se ja esta no canto do ecra (direita)
    MOV R5, [R0]        ; obtem largura da nave
    MOV R4, R1          ; copiar a coordenada X
    ADD R4, R5          ; adiciona largura
    MOV R5, MAX_COLUNA  ; largura do ecra
    CMP R4, R5          ; verifica se ja esta na posicao mais a direita
    JGT loop_rover      ; se ja estiver nao se mexe
    CALL move_x
    JMP loop_rover
check_missil:
    MOV R4, [MISSIL_DISPARADO]
    CMP R4, TRUE        ; ja disparamos um missil?
    JZ loop_rover
    CALL missil         ; disparar o missil
    JMP loop_rover
elimina_rover:
    CALL apaga_objeto
    RET

; **********************************************************************
; Processo
;
; objeto - Processo que trata do movimento do inimigo ou meteoro bom.
;
; Argumentos: R10 -> Numero da instancia do processo
;
; **********************************************************************
PROCESS sp_objeto_0           ; este stack pointer e irrelevante, vai ser substituido pelo correto depois
objeto:
    MOV R9, R10               ; copiar o numero da instancia do processo
    SHL R10, 1                ; multiplicar por dois para poder aceder corretamente a tabela
    MOV R11, sp_objetos       ; endereco da tabela com os stack pointers das varias instancias
    MOV SP, [R10+R11]         ; corrigir para o SP correto
novo_objeto:
    MOV R0, def_muito_distante; tabela que define o objeto no inicio
    CALL gera_x               ; gerar a coordenada aleatoria para X
    MOV R2, OBJETO_Y          ; o valor de Y e o topo do ecra (0)
    MOV [SEL_ECRA], R9        ; atualizar o ecra que esta selecionado
    CALL desenha_objeto       ; desenhar o objeto inicial no ecra
    CALL gera_indice          ; decidir se o objeto e um inimigo ou um meteoro bom
    CMP R4, INIMIGO1          ; calhou um inimigo do primeiro tipo?
    JZ inimigo1
    CMP R4, INIMIGO2          ; calhou um inimigo do segundo tipo?
    JZ inimigo2
    CMP R4, INIMIGO3          ; calhou um inimigo do terceiro tipo?
    JZ inimigo3
    CMP R4, METEORO_BOM2      ; calhou um meteoro bom do segundo tipo?
    JZ meteoro_bom2
meteoro_bom1:
    MOV R3, distancias_meteoro1; tabela que define o meteoro bom em funcao da distancia
    MOV R4, METEORO_BOM        ; codigo generico de meteoro bom
    JMP loop_objeto
meteoro_bom2:
    MOV R3, distancias_meteoro2; tabela que define o meteoro bom em funcao da distancia
    MOV R4, METEORO_BOM        ; codigo generico de meteoro bom
    JMP loop_objeto
inimigo1:
    MOV R3, distancias_inimigo1; tabela que define o inimigo em funcao da distancia
    MOV R4, INIMIGO            ; codigo generico de inimigo
    JMP loop_objeto
inimigo2:
    MOV R3, distancias_inimigo2; tabela que define o inimigo em funcao da distancia
    MOV R4, INIMIGO            ; codigo generico de inimigo
    JMP loop_objeto
inimigo3:
    MOV R3, distancias_inimigo3; tabela que define o inimigo em funcao da distancia
    MOV R4, INIMIGO            ; codigo generico de inimigo
loop_objeto:
    MOV R11, lock_objeto      ; endereco da tabela com os locks das varias instancias
    MOV R5, [R11+R10]         ; ler o LOCK
    MOV [SEL_ECRA], R9        ; atualizar o ecra que esta selecionado
    CMP R5, MORTO             ; o rover morreu?
    JZ gera_novo_objeto
move_baixo:
    MOV R5, MAX_LINHA         ; limite maximo da linha
    CMP R2, R5                ; ver se nao execedemos o limite
    JZ gera_novo_objeto       ; se estivermos na ultima linha so queremos apagar o objeto e criar um novo
    CALL move_objeto_y
; verificar colisao com o rover
    MOV R5, def_rover         ; endereco da tabela que define o objeto comque queremos verificar colisao
    MOV R6, [ROVER_X]         ; coordenadas do objeto com que queremos verificar colisao (rover)
    MOV R7, [ROVER_Y]
    CALL verifica_colisao
    CMP R8, FALSE             ; nao houve colisao?
    JZ verifica_missil
    CMP R4, INIMIGO           ; o objeto que colidiu e um inimigo?
    JZ colisao_inimigo
    MOV R5, 2                 ; vamos aumentar a energia por 10 ja que colidimos com um meteoro bom
    JMP som_colisao_aumento_energia
verifica_missil:
; verificar colisao com o missil
    MOV R5, [MISSIL_DISPARADO]
    CMP R5, FALSE             ; ha algum missil disparado neste momento?
    JZ loop_objeto            ; se nao ha nenhum missil disparado nao ha nada a fazer
    MOV R5, def_missil        ; endereco da tabela que define o objeto comque queremos verificar colisao
    MOV R6, [MISSIL_X]        ; coordenadas do objeto com que queremos verificar colisao (missil)
    MOV R7, [MISSIL_Y]
    CALL verifica_colisao
    CMP R8, FALSE             ; nao houve colisao?
    JZ loop_objeto
    MOV R5, MORTO
    MOV [lock_missil], R5     ; eliminar o missil
    MOV R5, 1                 ; aumentar energia por 5 por destruir um objeto
    CMP R4, INIMIGO           ; o objeto que colidiu e um inimigo?
    JNZ som_colisao_aumento_energia
; reproduzir o som associado a explosao do inimigo
    MOV R7, SEXPLOSAO         ; som a reproduzir
    MOV [PLAY_SOM], R7        ; reproduzir o som associado a explosao
    CALL animacao             ; se chocamos contra um inimigo ha animacao
    JMP colisao_aumento_energia
som_colisao_aumento_energia:
; reproduzir o som associado ao ganho de energia
    MOV R7, SENERGIA          ; som a reproduzir
    MOV [PLAY_SOM], R7        ; reproduzir o som associado a energia
colisao_aumento_energia:
    MOV [lock_energia], R5    ; aumentar a energia do rover
    MOV R5, 0
    MOV [lock_rover], R5      ; redesenhar o rover no sitio, repor os pixeis apagados pela colisao
    JMP gera_novo_objeto      ; eliminar este objeto gerando um novo
colisao_inimigo:
    MOV R5, MORTE_COL
    MOV [lock_controlo], R5
    JMP loop_objeto
gera_novo_objeto:
    CALL apaga_objeto         ; apagar o objeto do ecra
    MOV R5, [R11+R10]
    JMP novo_objeto           ; reiniciar todas as informacoes deste objeto (escolher nova posicao, escolher se e meteoro bom ou inimigo)

; **********************************************************************
; Processo
;
; missil - Processo que trata do movimento/disparo dos misseis
;
; **********************************************************************
PROCESS sp_missil
missil:
    MOV SP, sp_missil       ; re-inicializar o stack pointer
; diminuir a energia
    MOV R0, -1
    MOV [lock_energia], R0
; atualizar a variavel MISSIL_DISPARADO
    MOV R0, TRUE
    MOV [MISSIL_DISPARADO], R0 ; agora ha um missil disparado
; reproduzir o som associado ao missil
    MOV R0, STIRO            ; som a reproduzir
    MOV [PLAY_SOM], R0      ; reproduzir o som associado ao tiro

    MOV R0, def_missil      ; tabela que define o missil
; calcular o X inicial (X do rover + 1/2 do seu tamanho)
    MOV R1, [ROVER_X]
    MOV R5, NAVE_LX
    SHR R5, 1
    ADD R1, R5
; calcular o Y inicial (Y do rover - 1)
    MOV R2, [ROVER_Y]
    SUB R2, 1
; atualizar as coordenadas do missil
    MOV [MISSIL_X], R1
    MOV [MISSIL_Y], R2
; reset a contagem de movimentos
    MOV R3, 12
loop_missil:
    MOV R4, [lock_missil]
    MOV R5, ECRA_PRINCIPAL  ; garantir que estamos a trabalhar com o ecra certo
    MOV [SEL_ECRA], R5      ; atualizar o ecra que esta selecionado
    CMP R4, MORTO           ; se o rover tiver morrido vamos apagar o missil e terminar o processo
    JZ apagar_missil
    CMP R3, 0               ; verificar se ja andou as 12 vezes
    JZ apagar_missil        ; se andou vamos apagar
mover_missil:
    CALL apaga_objeto
    SUB R2, 1               ; atualizar linha (Y-1)
    MOV [MISSIL_Y], R2      ; atualizar linha em memoria
    CALL desenha_objeto
    SUB R3, 1               ; menos um movimento a fazer
    JMP loop_missil
apagar_missil:
    CALL apaga_objeto
    MOV R0, FALSE
    MOV [MISSIL_DISPARADO], R0 ; agora ja nao ha nenhum missil disparado
    RET

; **********************************************************************
; Processo
;
; animacao - Processo que trata de animar a explosao de um objeto
;
; Argumentos: R1 e R2 -> Coordenadas do objeto que explodiu
;             R9 -> Numero da instancia do objeto que explodiu
; **********************************************************************
PROCESS sp_animacao
animacao:
    MOV SP, sp_animacao     ; reinicializar o stack pointer
    MOV R3, frames          ; tabela com os varios frames da animacao
    MOV R4, 0               ; numero inicial do indice do frame
loop_animacao:
    MOV [SEL_ECRA], R9      ; atualizar o ecra que esta selecionado
    MOV R0, [R3+R4]         ; endereco da tabela que define o frame
    CALL desenha_objeto     ; desenhar o frame
    MOV R5, [lock_animacao] ; ler o lock para esperar ate a altura de mostrar o proximo frame
    MOV [SEL_ECRA], R9      ; atualizar o ecra que esta selecionado
    CALL apaga_objeto       ; apagar o frame antigo
    ADD R4, 2               ; indice seguinte da tabela
    CMP R4, 6               ; verificar se nao excedemos o indice maximo
    JNZ loop_animacao       ; enquanto nao excedemos continuamos
    RET

; **********************************************************************
; * Rotinas de interrupcoes
; **********************************************************************

int_meteoros:
    PUSH R0
    PUSH R1
    PUSH R2
    MOV R0, [estado]
    CMP R0, JOGO
    JNZ fim_int_meteoros

    MOV R1, lock_objeto
    MOV R2, NUM_OBJS
    SHL R2, 1
atualizar_objetos_int:
    MOV R0, [estado]
    SUB R2, 2
    MOV [R1+R2], R0
    CMP R2, 0
    JNZ atualizar_objetos_int
fim_int_meteoros:
    POP R2
    POP R1
    POP R0
    RFE

int_missil:
    PUSH R0
    MOV R0, [estado]
    CMP R0, JOGO
    JNZ fim_int_missil
    MOV [lock_missil], R0
    MOV [lock_animacao], R0
fim_int_missil:
    POP R0
    RFE

int_energia:
    PUSH R0
    MOV R0, [estado]
    CMP R0, JOGO
    JNZ fim_int_energia
    MOV R0, -1
    MOV [lock_energia], R0
fim_int_energia:
    POP R0
    RFE

; **********************************************************************
; * Rotinas
; **********************************************************************

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

gera_x:
; atribui uma coordenada aleatoria ao X de
; um objeto e guarda o no registo R1
;argumentos:
; R9 -> Numero da instancia do objeto
    PUSH R0
    MOV R0, TEC_COL         ; endereco do periferico de entrada
    MOVB R1, [R0]           ; ler do periferico de entrada (colunas)
    SHR R1, 4               ; elimina bits para alem dos bits 3-7
    MOV R0, OFFSET
    MUL R0, R9              ; multiplicar o offset pela instancia do objeto, para garantir que as coordenadas geradas sao diferentes
    ADD R1, R0              ; somar as coordenadas o offset
    MOV R0, MAX_COLUNA_OBJ  ; verificar se nao excedemos a coluna maxima
    CMP R1, R0
    JLE fim_gera_x          ; se nao excedemos nao se faz nada
; se excedemos o maximo o valor de R1 e no maximo 60, se subtrairmos 2 garantidamente ficamos dentro dos limites
    SUB R1, 2
fim_gera_x:
    POP R0
    RET

gera_indice:
; atribui um indice aleatorio a tabela
; escolhe_objeto e guarda os seus conteudos
; no registo R4, nao recebe argumentos
    PUSH R0
    PUSH R1
    MOV R1, TEC_COL             ; endereco do periferico de entrada
    MOV R4, 0                   ; inicializamos R3 a 0 para depois somar valores aleatorios
    MOVB R0, [R1]               ; ler do periferico de entrada (colunas)
    SHR R0, 7                   ; elimina bits para alem do ultimo
    ADD R4, R0                  ; somar ao indice o valor aleatorio
    MOVB R0, [R1]               ; ler do periferico de entrada (colunas)
    SHR R0, 5                   ; elimina bits para alem dos bits 6-8
    ADD R4, R0                  ; somar ao indice o valor aleatorio, agora o indice e um numero aleatorio de 0-8
    MOV R1, 2
    MUL R1, R4                  ; multiplicar por 2 para aceder a tabela
    MOV R0, escolhe_objeto
    ADD R1, R0
    MOV R4, [R1]                ; agora temos os conteudos de um indice aleatorio da tabela guardado em R4
    POP R1
    POP R0
    RET

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
    MOV R5, MASCARA_MSD
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

move_x:
; move a objeto para a esquerda ou direita
;argumentos:
; R0 -> endereco da tabela que define os pixeis do objeto
; R1 -> X
; R2 -> Y
; R3 -> direcao (1 = direita, -1 = esquerda, -2 = cima, 2 = baixo)
    CALL apaga_objeto   ; apagar objeto
    ADD R1, R3          ; obter a nova coordenada
    CALL desenha_objeto ; desenhar objeto
    RET

move_objeto_y:
; move um objeto (inimigo ou meteoro bom) para baixo
;argumentos:
; R0 -> endereco da tabela que define os pixeis do objeto
; R1 -> X
; R2 -> Y
; R3 -> tabela que define o objeto em funcao da distancia
    PUSH R4
    CALL apaga_objeto   ; apagar objeto
    ADD R2, 1           ; obter a nova coordenada
    MOV R4, PERTO
    CMP R2, R4          ; ja esta perto?
    JGE perto
    MOV R4, MEDIO
    CMP R2, R4          ; esta a distancia media?
    JGE medio
    MOV R4, LONGE
    CMP R2, R4          ; esta longe?
    JGE longe
    MOV R4, DISTANTE
    CMP R2, R4          ; esta distante?
    JGE distante
    JMP fim_move_nave
perto:
    MOV R0, [R3]
    JMP fim_move_nave
medio:
    MOV R0, [R3+2]
    JMP fim_move_nave
longe:
    MOV R0, [R3+4]
    JMP fim_move_nave
distante:
    MOV R0, [R3+6]
    JMP fim_move_nave
fim_move_nave:
    CALL desenha_objeto ; desenhar objeto
    POP R4
    RET

verifica_colisao:
; verifica colisao entre 2 objetos
;argumentos:
; R0 -> endereco da tabela que define os pixeis do obj1
; R1 -> X do obj1
; R2 -> Y do obj1
; R5 -> endereco da tabela que define os pixeis do obj2
; R6 -> X do obj2
; R7 -> Y do obj2
;retorno:
; R8 -> TRUE se colidiu, FALSE se nao
    PUSH R1
    PUSH R2
    PUSH R6
    PUSH R7
    PUSH R9
; adicionar largura ao X do obj2 e altura ao Y do obj2
    MOV R9, [R5]    ; obter largura do obj2
    ADD R6, R9      ; adicionar a atual posicao
    MOV R9, [R5+2]  ; obter a altura do obj2
    ADD R7, R9      ; adicionar a atual posicao
; comparacoes
    CMP R1, R6      ; comparar se o X do obj1 esta a direita do X+largura do obj2
    JGE nao_colidiu ; se estiver nao colidiram
    CMP R2, R7      ; comparar se o Y do obj1 esta abaixo do Y+altura do obj2
    JGE nao_colidiu ; se estiver nao colidiram
; reverter X e Y do obj2
    SUB R7, R9
    MOV R9, [R5]
    SUB R6, R9
; adicionar largura ao X do obj1 e altura ao Y do obj1
    MOV R9, [R0]    ; obter largura do obj1
    ADD R1, R9      ; adicionar a atual posicao
    MOV R9, [R0+2]  ; obter a altura do obj1
    ADD R2, R9      ; adicionar a atual posicao
; comparacoes 2
    CMP R1, R6      ; comparar se o X+largura do obj1 esta a esquerda do X do obj2
    JLE nao_colidiu ; se estiver nao colidiram
    CMP R2, R7      ; comparar se o Y+altura do obj1 esta acima do Y do obj2
    JLE nao_colidiu ; se estiver nao colidiram
    MOV R8, TRUE    ; se chegou aqui houve colisao
    JMP fim_verifica_colisao
nao_colidiu:
    MOV R8, FALSE
fim_verifica_colisao:
    POP R9
    POP R7
    POP R6
    POP R2
    POP R1
    RET

desenha_objeto:
; desenha um objeto
;argumentos:
; R0 -> endereco da tabela que define os pixeis do objeto
; R1 -> X
; R2 -> Y
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    MOV R3, [R0]        ; obtem a largura do objeto
    MOV R4, [R0+2]      ; obtem a altura do objeto
    ADD R3, R1          ; coluna final
    ADD R4, R2          ; linha final
    SUB R4, 1
    CALL atualiza_linha ; verificar se a linha final nao excede os limites do ecra
    MOV R7, 4
    ADD R7, R0          ; endereco da cor do primeiro pixel
    MOV R5, R1          ; copia das coordenadas iniciais da coluna (esta nao e alterada)
    MOV R8, R2          ; copia das coordenadas iniciais da linha
desenha_colunas:        ; desenha os pixels do boneco a partir da tabela
    MOV R6, [R7]        ; obtem a cor do proximo pixel
    CMP R6, 0           ; se a cor for 0 nao precisamos alterar
    JZ skip_pixel
    MOV [SEL_COLUNA], R1; seleciona a coluna
    MOV [SEL_LINHA], R8 ; seleciona a linha
    MOV [SEL_PIXEL], R6 ; altera a cor do pixel na linha e coluna selecionadas
skip_pixel:
    ADD R7, 2           ; endereco da cor do proximo pixel
    ADD R1, 1           ; proxima coluna
    CMP R1, R3          ; verificar se ja tratamos da largura toda
    JNZ desenha_colunas ; continua ate percorrer toda a largura do objeto
    ADD R8, 1           ; proxima linha
    MOV R1, R5          ; reiniciar as colunas
    CMP R8, R4          ; verificar se ja tratamos da altura toda
    JLE desenha_colunas ; continuar ate tratar da altura toda
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    RET

apaga_objeto:
; apaga um objeto
;argumentos:
; R0 -> endereco da tabela que define os pixeis do objeto
; R1 -> X
; R2 -> Y
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    MOV R3, [R0]        ; obtem a largura do objeto
    MOV R4, [R0+2]      ; obtem a altura do objeto
    ADD R3, R1          ; coluna final
    ADD R4, R2          ; linha final
    SUB R4, 1
    CALL atualiza_linha ; verificar se a linha final nao excede os limites do ecra
    MOV R7, 4
    ADD R7, R0          ; endereco da cor do primeiro pixel
    MOV R5, R1          ; copia das coordenadas iniciais da coluna (esta nao e alterada)
    MOV R8, R2          ; copia das coordenadas iniciais da linha
apaga_colunas:          ; apaga os pixeis do boneco
    MOV R6, [R7]        ; obtem a cor do proximo pixel
    CMP R6, 0           ; se a cor for 0 nao precisamos apagar
    JZ skip_pixel_apaga
    MOV [SEL_COLUNA], R1; seleciona a coluna
    MOV [SEL_LINHA], R8 ; seleciona a linha
    MOV R9, 0
    MOV [SEL_PIXEL], R9 ; apaga o pixel
skip_pixel_apaga:
    ADD R7, 2           ; endereco da cor do proximo pixel
    ADD R1, 1           ; proxima coluna
    CMP R1, R3          ; verificar se ja tratamos da largura toda
    JNZ apaga_colunas ; continua ate percorrer toda a largura do objeto
    ADD R8, 1           ; proxima linha
    MOV R1, R5          ; reiniciar as colunas
    CMP R8, R4          ; verificar se ja tratamos da altura toda
    JLE apaga_colunas ; continuar ate tratar da altura toda
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
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
