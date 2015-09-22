.module video

.globl _cpc_SetInk

_cpc_SetInk::
	;LD HL,#2
	;ADD HL,SP
	POP AF	;CALLEE, pasa parámetros en pila 
	
	pop hl
	push af
	
	LD A,L
	LD B,H
	ld C,H
	JP 0XBC32