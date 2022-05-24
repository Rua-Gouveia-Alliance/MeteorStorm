; *********************************************************************
; * IST-UL
; * Modulo:    lab3.asm
; * Descrição: Exemplifica o acesso a um teclado.
; *            Lê uma linha do teclado, verificando se há alguma tecla
; *            premida nessa linha.
; *
; * Nota: Observe a forma como se acede aos periféricos de 8 bits
; *       através da instrução MOVB
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATENÇÃO: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto não altera o valor de 16 bits e permite distinguir números de identificadores
DISPLAYS   EQU 0A000H	; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 16		; linha a testar (comecamos na 4a linha, mas por causa do shift right inicial inicializamos ao dobro)
MASCARA    EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
SHIFTR     EQU 2		; dividir por 2 para fazer o shift right

; **********************************************************************
; * Código
; **********************************************************************
PLACE      0
inicio:
; inicializações
    MOV  R2, TEC_LIN	; endereço do periférico das linhas
    MOV  R3, TEC_COL	; endereço do periférico das colunas
    MOV  R4, DISPLAYS	; endereço do periférico dos displays
	MOV  R5, MASCARA	; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOV  R6, SHIFTR		; shift right

; corpo principal do programa
ciclo:
	MOV  R1, 0
    MOVB [R4], R1		; escreve linha e coluna a zero nos displays

espera_tecla:			; neste ciclo espera-se até uma tecla ser premida
	MOV  R1, LINHA		; comecar por testar a linha 4
	loop_espera:
		DIV R1, R6		; shift right
		CMP R1, 0		; verificar se estamos a testar uma linha valida
		JZ espera_tecla	; reinicializar o valor da linha e recomecar o ciclo caso linha seja invalida
		MOVB [R2], R1	; escrever no periférico de saída (linhas)
		MOVB R0, [R3]	; ler do periférico de entrada (colunas)
		AND  R0, R5		; elimina bits para além dos bits 0-3
		CMP  R0, 0		; há tecla premida?
		JZ  loop_espera	; se nenhuma tecla premida, repete
    SHL  R1, 4			; coloca linha no nibble high
    OR   R1, R0			; junta coluna (nibble low)
    MOVB [R4], R1		; escreve linha e coluna nos displays

ha_tecla:				; neste ciclo espera-se até NENHUMA tecla estar premida
    MOV  R1, LINHA		; testar a linha 4  (R1 tinha sido alterado)
	loop_ha:
		DIV R1, R6      ; shift right
		CMP R1, 0       ; verificar se a linha esta a 0
		JZ ciclo        ; se a linha ta a 0 é porque já verificamos todas e nao ha teclas premidas
		MOVB [R2], R1   ; escrever no periférico de saída (linhas)
		MOVB R0, [R3]   ; ler do periférico de entrada (colunas)
		AND  R0, R5     ; elimina bits para além dos bits 0-3
		CMP  R0, 0      ; há tecla premida?
		JNZ  ha_tecla    ; se ainda houver uma tecla premida reinicia as linhas e volta ao inicio do ciclo exteriror
		JMP loop_ha     ; continua no loop ate todas as linhas terem sido testadas

