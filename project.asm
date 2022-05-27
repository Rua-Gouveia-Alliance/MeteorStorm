
; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS    EQU 0A000H	; endereco dos displays de 7 segmentos (periferico POUT-1)
TEC_LIN	    EQU 0C000H	; endereco das linhas do teclado (periferico POUT-2)
TEC_COL     EQU 0E000H	; endereco das colunas do teclado (periferico PIN)
LINHA       EQU 16      ; linha a testar (comecamos na 4a linha, mas por causa do shift right inicial inicializamos ao dobro)
MASCARA     EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
ENERGIA	    EQU 064H	; valor inicial da energia
SENERGIA    EQU 05H		; valor de energia a subtrair

; **********************************************************************
; * Codigo
; **********************************************************************
PLACE      0
inicio:
; inicializacoes
    MOV	R2, TEC_LIN		; endereco do periferico das linhas
    MOV	R3, TEC_COL		; endereco do periferico das colunas
    MOV	R4, DISPLAYS	; endereco do periferico dos displays
    MOV	R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV	R6, ENERGIA		; valor inicial da energia
    MOV R7, SENERGIA	; valor de energia a subtrair
    MOV R8, 011H		; coordenadas da tecla que subtrai a energia

; corpo principal do programa
main_loop:
    MOV  R1, 0
    MOV [R4], R6		; escreve a energia nos displays

espera_tecla:			; neste ciclo espera-se ate uma tecla ser premida
    MOV  R1, LINHA		; comecar por testar a linha 4
    loop_espera:
    SHR	R1, 1			; shift right
    CMP	R1, 0			; verificar se estamos a testar uma linha valida
    JZ	espera_tecla	; reinicializar o valor da linha e recomecar o ciclo caso linha seja invalida
    MOVB [R2], R1		; escrever no periferico de saída (linhas)
    MOVB R0, [R3]		; ler do periferico de entrada (colunas)
    AND R0, R5			; elimina bits para além dos bits 0-3
    CMP	R0, 0			; ha tecla premida?
    JZ	loop_espera		; se nenhuma tecla premida, repete
    MOV	R9, R1			; guardar o valor da linha
    SHL	R1, 4			; coloca linha no nibble high
    OR	R1, R0			; junta coluna (nibble low)
    CMP R1, R8			; verifica se carregamos na tecla de mudar energia
    JZ muda_energia		; mudar energia caso a tecla tenha sido pressionada

ha_tecla:				; neste ciclo espera-se ate nenhuma tecla estar premida
    MOVB [R2], R9		; escrever no periferico de saída (linhas)
    MOVB R0, [R3]		; ler do periferico de entrada (colunas)
    AND  R0, R5			; elimina bits para além dos bits 0-3
    CMP	R0, 0			; ha tecla premida?
    JNZ	ha_tecla		; se ainda houver uma tecla premida repete o loop
    JMP	main_loop		; volta ao inicio

muda_energia:
    SUB R6, R7			; subtrair energia
    JMP ha_tecla		; esperar que a tecla deixe de ser pressionada
