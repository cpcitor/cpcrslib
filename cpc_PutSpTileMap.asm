; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2007       **
; ******************************************************

XLIB cpc_PutSpTileMap		;se encarga de actualizar los tiles que toca el sprite 

XREF tiles_tocados
XREF pantalla_juego					;datos de la pantalla, cada byte indica un tile
XREF posiciones_super_buffer
XREF tiles

LIB cpc_UpdTileTable

.cpc_PutSpTileMap
;según las coordenadas x,y que tenga el sprite, se dibuja en el buffer
    ;ld ix,2
    ;add ix,sp
    ;ld l,(ix+0)
    ;ld h,(ix+1)	;HL apunta al sprite
    
	
	
    ex de,hl	;4
	LD IXH,d	;9
    LD IXL,e	;9   
    ;22
  ;  ex de,hl
 
   ; push hl	;11
   ; pop ix	;14
    ;25
    


    ld e,(ix+0)
    ld d,(ix+1)
    
    LD A,(de)
    ld (bit_ancho+1),a
    
    inc de
    LD A,(de)
	ld (bit_alto+1),a
	
	
	;ld l,a  ;L tiene alto
	
	ld e,(ix+10)
    ld d,(ix+11)	;recoje coordenadas
    
  	ld c,e
    ld b,d  
    
	;E tiene el bloque en horizontal
	srl e		;E tiene bloque horizontal
	
	srl d
	srl d
	srl d		;D tiene bloque vertical
	
				;B tiene coordenada vertical
				;C tiene coordenada horizontal

;1. se marcan los tiles correspondientes como tocados para luego redibujar.

	CALL bucle_restauracion_fondo   
	
	        
   ;actualizando las coordenadas anteriores.
    ld e,(ix+8)
    ld d,(ix+9)
    ld (ix+10),e
    ld (ix+11),d
    ld c,e
    ld b,d
	;E tiene el bloque en horizontal
	srl e
		;D tiene el bloque en vertical
	srl d
	srl d
	srl d

;1. se marcan los tiles correspondientes como tocados para luego redibujar.


.bucle_restauracion_fondo		; la restauración se hace partiendo de los bloques tocados.
								; se miran las coordenadas anteriores de los sprites y se buscan los bloques

								; correspondientes, que serán los que se van a actualizar.

								
; POR AHORA SOLO SPRITES DE 8x16 pixeles modo 0								


;si ancho impar-> el número de comprobaciones es anchoMOD2
;si ancho par-> depende de la coordenada inicial, si es par ->ancho/2, si no, ancho/2+1


.bit_alto ; *parametro
	ld a,0
	add b  ;y+alto
	ld l,a
	srl a
	srl a
	srl a 
	sub d   ;ty2-ty  = tiles-alto

	ld h,a   

	ld A,L
	AND @00001111
;    OR  @00000000
    
;	add d		;+tile ty2
		
;	sla a
;	sla a
;	sla a		;x8
;	sub l		;-(alto+coordy)
	jp z, cont_proceso2	
	inc h
.cont_proceso2	
	ld a,h
	LD (pasos_alto_x+1),A	
	

.bit_ancho	; *parametro
    ld a,0
    add c	;x+ancho
    srl a	;/2
    jp nc, lop2	;si c entonces hay un bloque más
    inc a    
.lop2    
    sub e
.cont_proceso	

;Ahora se comprueba el alto del sprite.	Se mira si es múltiplo de 8.

.pasos_ancho_x    ; *parametro
    ld b,a
.bucle_pasos_ancho
    push de
    ;ld a,(pasos_alto)
.pasos_alto_x ; *parametro
	ld c,0
    .bucle_pasos_alto
	    call cpc_UpdTileTable
		inc d
		dec c
		jp nz,bucle_pasos_alto
		
	pop de
	inc e
	dec b
	jp nz,bucle_pasos_ancho
    ret
 