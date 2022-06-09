
; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS    EQU 0A000H  ; endereco dos displays de 7 segmentos (periferico POUT-1)
TEC_LIN     EQU 0C000H  ; endereco das linhas do teclado (periferico POUT-2)
TEC_COL     EQU 0E000H  ; endereco das colunas do teclado (periferico PIN)
LINHA_TEST  EQU 16      ; linha a testar (comecamos na 4a linha, mas por causa do shift right inicial inicializamos ao dobro)
MASCARA_MSD EQU 0FH     ; para remover os 4 bits de maior peso, ao ler as colunas do teclado
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
MORTO       EQU 2       ; estado em que o jogo esta (jogador morto)
BG_JOGO     EQU 0       ; imagem de fundo do jogo
BG_HOME     EQU 1       ; imagem de fundo do home screen
BG_ENERGIA  EQU 2       ; imagem de fundo de quando se morre por falta de energia

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

DIREITA     EQU 1       ; valor a adicionar para ir para a direita

NAVE_X      EQU 30      ; coluna da nave
NAVE_Y      EQU 28      ; linha da nave
NAVE_LX     EQU 5       ; largura da nave
NAVE_LY     EQU 4       ; altura da nave

COMECAR     EQU 0       ; sinal para o processo de controlo, comecar jogo
MORTE_ENG   EQU 1       ; sinal para o processo de controlo, morte por falta de energia

INIMIGO_X   EQU 20      ; coluna do inimigo
INIMIGO_Y   EQU 0       ; linha do inimigo
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
LONGE       EQU 5       ; coordenada a partir da qual se considera longe
MEDIO       EQU 9       ; coordenada a partir da qual se considera distancia media
PERTO       EQU 14      ; coordenada a partir da qual se considera perto

ITER_ALEATORIO EQU 3    ; repeticoes que o ciclo para gerar um numero aleatorio faz

YELLOW      EQU 0FFF0H  ; cor amarelo em ARGB
RED         EQU 0FF00H  ; cor vermelho em ARGB
GREY        EQU 0FF00H  ; cor cinzento em ARGB

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

    STACK 100H          ; espaco reservado para a stack do processo que trata do inimigo
sp_inimigo:

lock_controlo:          ; variavel para controlar o processo controlo
    LOCK    0

lock_energia:           ; variavel para controlar o processo energia
    LOCK    0

lock_rover:             ; variavel para controlar o processo rover
    LOCK    0

lock_inimigo:           ; variavel para controlar o processo inimigo
    LOCK    0

lock_main:
    LOCK    0

estado:
    WORD HOME           ; estado do jogo

def_rover:              ; tabela que define o rover (largura, altura e cor dos pixeis)
    WORD    NAVE_LX
    WORD    NAVE_LY
    WORD    0, 0, YELLOW, 0, 0
    WORD    YELLOW, 0, YELLOW, 0, YELLOW
    WORD    YELLOW, YELLOW, YELLOW, YELLOW, YELLOW
    WORD    0, YELLOW, 0, YELLOW, 0

def_muito_distante:     ; tabela que define o inimigo/metero bom muito distante (largura, altura e cor dos pixeis)
    WORD    OBJETO_MDX
    WORD    OBJETO_MDY
    WORD    GREY

def_distante:     ; tabela que define o inimigo/metero bom distante (largura, altura e cor dos pixeis)
    WORD    OBJETO_DX
    WORD    OBJETO_DY
    WORD    RED, RED    ; mudar esta cor pa cinzento depois
    WORD    RED, RED    ; mudar esta cor pa cinzento depois

def_inimigo_perto:      ; tabela que define o inimigo perto (largura, altura e cor dos pixeis)
    WORD    OBJETO_PX
    WORD    OBJETO_PY
    WORD    RED, 0, 0, 0, RED
    WORD    RED, 0, RED, 0, RED
    WORD    0, RED, RED, RED, 0
    WORD    RED, 0, RED, 0, RED
    WORD    RED, 0, 0, 0, RED

def_inimigo_medio:     ; tabela que define o inimigo a distancia media (largura, altura e cor dos pixeis)
    WORD    OBJETO_MX
    WORD    OBJETO_MY
    WORD    RED, 0, 0, RED
    WORD    RED, 0, 0, RED
    WORD    0, RED, RED, 0
    WORD    RED, 0, 0, RED

def_inimigo_longe:      ; tabela que define o inimigo longe (largura, altura e cor dos pixeis)
    WORD    OBJETO_LX
    WORD    OBJETO_LY
    WORD    RED, 0, RED
    WORD    0, RED, 0
    WORD    RED, 0, RED

distancias_inimigo:
    WORD def_inimigo_perto
    WORD def_inimigo_medio
    WORD def_inimigo_longe
    WORD def_distante

;distancias_meteoro:
;    WORD def_meteoro_perto
;    WORD def_meteoro_medio
;    WORD def_meteoro_longe
;    WORD def_distante

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
    MOV R0, BG_HOME             ; cenario de fundo do home
    MOV [BACKGROUND], R0        ; seleciona o cenario de fundo

    MOV R0, 0
    MOV [DISPLAYS], R0          ; setup inicial do display

; executar processos
    CALL controlo
    CALL teclado
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
    MOV SP, sp_controlo
    MOV R0, [lock_controlo]     ; ler o LOCK
    MOV R1, COMECAR
    CMP R0, R1
    JZ comecar_jogo
    MOV R1, MORTE_ENG
    CMP R0, R1
    JZ morte_falta_energia
    JMP controlo
comecar_jogo:
; prepara o inicio do jogo
    MOV R0, BG_JOGO             ; cenario de fundo do jogo
    MOV [BACKGROUND], R0        ; seleciona o cenario de fundo
    MOV R0, JOGO                ; novo estado
    MOV [estado], R0            ; atualizar o estado do jogo

    CALL energia                ; iniciar a energia
    CALL rover                  ; iniciar o rover
    CALL inimigo                ; iniciar o inimigo

    JMP controlo
morte_falta_energia:
    MOV [DEL_ECRAS], R0         ; apagar todos os desenhos no ecra
    MOV R0, BG_ENERGIA          ; cenario de fundo da morte por falta de energia
    MOV [BACKGROUND], R0        ; atualizar cenario de fundo

    JMP controlo

; **********************************************************************
; Processo
;
; teclado - Processo que trata de detetar cliques no teclado
;
; **********************************************************************
PROCESS sp_teclado
teclado:
    MOV SP, sp_teclado
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
home:
    ; premir c para comecar
    MOV R0, TSTART
    CMP R5, R0
    MOV R0, COMECAR
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
    JZ unlock_inimigo

    JMP espera_tecla
largou:                 ; neste ciclo espera-se ate largar a tecla
    MOVB [R3], R9       ; escrever no periferico de saída (linhas)
    MOVB R0, [R4]       ; ler do periferico de entrada (colunas)
    AND  R0, R5         ; elimina bits para além dos bits 0-3
    CMP R0, 0           ; ha tecla premida?
    JNZ largou          ; se ainda houver uma tecla premida repete o loop
    JMP espera_tecla    ; volta ao da funcao
unlock_controlo:
    MOV [lock_controlo], R0
    JMP largou
    YIELD
unlock_energia:
    MOV [lock_energia], R0
    JMP largou
    YIELD
unlock_rover:
    MOV [lock_rover], R0
    YIELD
    CALL delay
    JMP espera_tecla
unlock_inimigo:
    MOV [lock_inimigo], R0
    JMP largou

; **********************************************************************
; Processo
;
; energia - Processo que trata da energia.
;
; **********************************************************************
PROCESS sp_energia
energia:
    MOV SP, sp_energia
    MOV R1, MAX_ENERGIA         ; valor inicial da energia
    CALL hex_p_dec_representacao
ciclo_energia:
    MOV [DISPLAYS], R0          ; atualizar o valor no ecra
    MOV R0, [lock_energia]      ; ler o LOCK, contem o valor a adicionar ou multiplicar
    JMP muda_energia            ; alterar a energia em funcao do calor lido
muda_energia:
; mudar o valor da energia
    MOV R2, 5
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
    MOV [DISPLAYS], R0  ; evitar mostrar um valor negativo de energia
    MOV R0, MORTE_ENG
    MOV [lock_controlo], R0
    RET

; **********************************************************************
; Processo
;
; rover - Processo que trata do movimento do rover.
;
; **********************************************************************
PROCESS sp_rover
rover:
    MOV SP, sp_rover
    MOV R0, def_rover         ; tabela que define o rover
    MOV R1, NAVE_X
    MOV R2, NAVE_Y
    CALL desenha_objeto       ; desenhar o rover inicial no ecra
loop_rover:
    MOV R3, [lock_rover]      ; ler o LOCK, contem a direcao em que mexer o rover
    CMP R3, DIREITA           ; vamos mexer para a direita?
    JZ verificacao_direita
verificacao_esquerda:
    CMP R1, MIN_COLUNA        ; verifica se ja esta na posicao mais a esquerda
    JZ loop_rover             ; se sim nao fazemos nada
    CALL move_x
    JMP loop_rover
verificacao_direita:
    ; verifica se ja esta no canto do ecra (direita)
    MOV R5, [R0]        ; obtem largura da nave
    MOV R4, R1          ; copiar a coordenada X
    ADD R4, R5          ; adiciona largura
    MOV R5, MAX_COLUNA  ; largura do ecra
    CMP R4, R5          ; verifica se ja esta na posicao mais a direita
    JGT loop_rover      ; se ja estiver nao se mexe
    CALL move_x
    JMP loop_rover

; **********************************************************************
; Processo
;
; inimigo - Processo que trata do movimento do inimigo.
;
; **********************************************************************
PROCESS sp_inimigo
inimigo:
    MOV SP, sp_inimigo
    MOV R0, def_muito_distante; tabela que define o inimigo
    CALL set_x                ; gerar a coordenada aleatoria para X
    MOV R2, INIMIGO_Y         ; o valor de Y e o topo do ecra (0)
    MOV R3, distancias_inimigo; tabela que define o inimigo em funcao da distancia
    CALL desenha_objeto       ; desenhar o inimigo inicial no ecra
loop_inimigo:
    MOV R4, [lock_inimigo]    ; ler o LOCK
verificacao_baixo:
    MOV R4, MAX_LINHA   ; limite maximo da linha
    CMP R2, R4          ; ver se nao execedemos o limite
    JZ apagar_inimigo   ; se estivermos na ultima linha so queremos apagar o objeto
    CALL move_objeto_y
    JMP loop_inimigo
apagar_inimigo:
    CALL apaga_objeto
    RET

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

set_x:
; atribui uma coordenada aleatoria ao X de
; um objeto e guarda o no registo R1, nao
; recebe argumentos
    PUSH R0
    PUSH R2
    PUSH R3
    MOV R1, 0               ; inicializamos R1 a 0 para depois somar valores aleatorios
    MOV R2, ITER_ALEATORIO  ; R2 e um contador
    MOV R3, TEC_COL         ; endereco do periferico de entrada
gera_aleatorio:
    MOVB R0, [R3]           ; ler do periferico de entrada (colunas)
    SHR R0, 4               ; elimina bits para alem dos bits 3-7
    ADD R1, R0              ; somar as coordenadas o valor aleatorio
    SUB R2, 1               ; menos um ciclo a fazer
; repetimos 3 vezes, para no maximo a coordenada gerada ser 45 e nao exceder 58 (o limite do ecra menos a largura maxima do boneco)
    JNZ gera_aleatorio
    POP R3
    POP R2
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
    MOV [SEL_COLUNA], R1; seleciona a coluna
    MOV [SEL_LINHA], R8 ; seleciona a linha
    MOV [SEL_PIXEL], R6 ; altera a cor do pixel na linha e coluna selecionadas
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
    MOV R3, [R0]        ; obtem a largura do objeto
    MOV R4, [R0+2]      ; obtem a altura do objeto
    ADD R3, R1          ; coluna final
    ADD R4, R2          ; linha final
    SUB R4, 1
    CALL atualiza_linha ; verificar se a linha final nao excede os limites do ecra
    MOV R5, R1          ; copia das coordenadas iniciais da coluna
    MOV R7, R2          ; copia das coordenadas iniciais da linha
    MOV R6, 0           ; escolhe cor 0 (apagar)
apaga_colunas:          ; desenha os pixels do boneco a partir da tabela
    MOV [SEL_COLUNA], R1; seleciona a coluna
    MOV [SEL_LINHA], R7 ; seleciona a linha
    MOV [SEL_PIXEL], R6 ; apaga o pixel na linha e coluna selecionadas
    ADD R1, 1           ; proxima coluna
    CMP R1, R3          ; verificar se ja tratamos da largura toda
    JNZ apaga_colunas   ; continua ate percorrer toda a largura do objeto
    ADD R7, 1           ; proxima linha
    MOV R1, R5          ; reiniciar as colunas
    CMP R7, R4          ; verificar se ja tratamos da altura toda
    JLE apaga_colunas   ; continuar ate tratar da altura toda
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
