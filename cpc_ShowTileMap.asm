; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2007       **
; ******************************************************

XLIB cpc_ShowTileMap	;	para una pantalla de 64x160 bytes. Superbuffer 8192bytes
								;   los tiles son de 2x8 bytes

XREF tiles
XREF pantalla_juego					;datos de la pantalla, cada byte indica un tile
XREF posiciones_super_buffer		
XREF posicion_inicial_area_visible
XREF posicion_inicial_superbuffer
XREF ancho_pantalla_bytes
XREF ancho_pantalla_bytes_visible
XREF alto_pantalla_bytes
XREF posiciones_pantalla



.cpc_ShowTileMap

; En HL viene el ancho a usar
ld a,l
or a ;cp 0
jp z, cont_normal
ld (otro_ancho+1),a
ex de,hl
ld hl,ancho_pantalla_bytes ;-ancho_pantalla_bytes_visible
sbc hl,de
ld a,l
ld (ancho_mostrable+1),a

.cont_normal
	xor a
	ld (contador_tiles),a
	ld hl,pantalla_juego
	call transferir_pantalla_a_superbuffer
	
;parte donde se transfiere el superbuffer completo a la pantalla	

;	ld hl,posicion_inicial_area_visible
	ld hl,(posiciones_pantalla)
	ld de,posicion_inicial_superbuffer
	
.otro_ancho	
	ld b,ancho_pantalla_bytes_visible
	ld c,alto_pantalla_bytes
	jp cpc_PutSp		;cambiar la rutina por una que dibuje desde superbuffer
	;ret

; A partir de la dirección del vector de bloques se dibuja el mapeado en pantalla


.transferir_pantalla_a_superbuffer

	
	PUSH HL
	POP IX	;IX lleva los datos de la pantalla
	LD DE,(posiciones_super_buffer)
.bucle_dibujado_fondo
	;Leo en HL el tile a meter en el superbuffer
	LD L,(IX+0)
	LD H,0
	ADD HL,HL	;x2
	ADD HL,HL	;x4
	ADD HL,HL	;x8
	ADD HL,HL	;x16
	LD BC,tiles
	ADD HL,BC	;hl apunta al tile a transferir
	;me falta conocer el destino. IY apunta al destino
	EX DE,HL	
	PUSH HL
	call transferir_map_sbuffer		;DE origen HL destino
	POP HL
	INC IX	;Siguiente byte
	LD A,(IX+0)
	CP $FF	;El fin de los datos se marca con $FF, no hay un tile que sea $FF
	RET Z
	EX DE,HL
	LD A,(contador_tiles)
	CP ancho_pantalla_bytes/2-1 ;31	;son 32 tiles de ancho
	JP Z,incremento2
	INC A
	LD (contador_tiles),A
	INC DE
	INC DE	;para pasar a la siguiente posición
	;si ya se va por el 18 el salto es mayor, es 
	JP bucle_dibujado_fondo

.incremento2
	XOR A
	LD (contador_tiles),A
	LD BC, 7*ancho_pantalla_bytes+2 ;450 ; 64x7+2 48x7+2  1084 ;72x15+4
	EX DE,HL
	ADD HL,BC	
	EX DE,HL
	JP bucle_dibujado_fondo

.contador_tiles defb 0	
	
	
	

.transferir_map_sbuffer	

		ld bc,ancho_pantalla_bytes-1 ;63
		
		defb $fD
   		LD H,8		;ALTO, SE PUEDE TRABAJAR CON HX DIRECTAMENTE

.loop_alto_map_sbuffer
.loop_ancho_map_sbuffer		
	ld A,(DE)
	ld (HL),A
	inc de
	inc hl
	ld A,(DE)
	ld (HL),A
	inc de

defb $fD
dec h
ret z
;hay que sumar el ancho de la pantalla en bytes para pasar a la siguiente línea

	add HL,BC	
	;pop BC
	jp loop_alto_map_sbuffer
	
	
;defb 'm','o','c'
.cpc_PutSp	; dibujar en pantalla el sprite
;di
ld a,b
ld b,c
ld c,a
.loop_alto_2
	push bc
	ld b,c
	push hl
.loop_ancho_2		
	ld A,(DE)
	ld (hl),a
	inc de
	inc hl
	djnz loop_ancho_2
	
	;incremento DE con el ancho de la pantalla-el del sprite
	ex de,hl
.ancho_mostrable	
	ld bc,ancho_pantalla_bytes-ancho_pantalla_bytes_visible
	add hl,bc
	ex de,hl
	pop hl
	ld A,H
	add $08
	ld H,A
	sub $C0
	jp nc,sig_linea_2
	ld bc,$c050
	add HL,BC	
	.sig_linea_2
	pop BC
	djnz loop_alto_2
;ei
ret



