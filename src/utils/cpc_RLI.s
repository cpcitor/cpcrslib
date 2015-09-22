.module utils

.globl _cpc_RLI		;rota las líneas que se le digan hacia la izq y mete lo rotado por la derecha.

_cpc_RLI::

	pop af
	pop hl
	pop de
	push af
	;ld a,e
	;LD (alto_cpc_RLI+1),A
	LD A,d 	;ancho
	LD (ancho_cpc_RLI+1),A
	

	DEC HL
alto_cpc_RLI:
	LD A,e					; parametro
ciclo0_cpc_RLI:
	PUSH AF
	PUSH HL
	INC HL
	LD A,(HL)
	LD D,H
	LD E,L
	DEC HL
	LD B, #0
ancho_cpc_RLI:
	LD C,#50	; parametro
	LDDR
	INC HL
	LD (HL),A
	POP HL
	POP AF
	DEC A
	RET Z
	LD BC,#0X800	;salto de línea, ojo salto caracter.
	ADD HL,BC
	JP NC,ciclo0_cpc_RLI ;sig_linea_2zz		;si no desborda va a la siguiente linea
	LD BC,#0XC050
	ADD HL,BC
	JP ciclo0_cpc_RLI