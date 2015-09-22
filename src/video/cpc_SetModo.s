.module video

.globl	_cpc_SetModo
;Set mode using firmware
_cpc_SetModo::
 	;LD A,L
  	;LD HL,#2
 	;ADD HL,SP
 	;LD a,(HL)			; COMPROBAR QUE EL VALOR VAYA A L!!
	
   	ld a,l
	JP 0XBC0E