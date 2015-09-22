.module gphstrstd

.include  "gphstrstd.s"


.globl _cpc_PrintGphStrStd

_cpc_PrintGphStrStd::
	push ix
	ld ix,#4
	add ix,sp
	ld l,3  (ix)
	ld h,4 (ix)	;destino
	ld e,1  (ix)
	ld d,2 (ix)	;texto origen
	ld a,0 (ix) ;color
	;ld (#cpc_PrintGphStrStd0+1),a
	call _cpc_PrintGphStrStd0
	pop ix
	ret