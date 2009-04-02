; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2007       **
; ******************************************************

XLIB cpc_PrintGphStr0M1
XDEF direcc_destino0_m1
XDEF colores_cambM1

XREF cola_impresion0
XREF pos_cola0
XREF first_char



LIB cpc_Chars

.cpc_PrintGphStr0M1  

;DE destino
;HL origen
;ex de,hl


;trabajo previo: Para tener una lista de trabajos de impresión. No se interrumpe
;la impresión en curso.
ld a,(imprimiendo)
cp 1
jp z,add_elemento

ld (direcc_destino),hl
ex de,hl
call bucle_texto0

;antes de terminar, se mira si hay algo en cola.
.bucle_cola_impresion
ld a,(elementos_cola)
or a
jp z,terminar_impresion
call leer_elemento
jp bucle_cola_impresion


.terminar_impresion
xor a
ld (imprimiendo),a
ret

.entrar_cola_impresion
;si se está imprimiendo se mete el valor en la cola

ret
.add_elemento
di
	ld ix,(pos_cola)
	ld (ix+0),l
	ld (ix+1),h
	ld (ix+2),e
	ld (ix+3),d
	inc ix
	inc ix
	inc ix
	inc ix
	ld (pos_cola),ix
	
	ld hl,elementos_cola
	inc (hl)
	;Se añaden los valores hl y de
ei
	ret
.leer_elemento
di
	ld ix,(pos_cola)
	ld l,(ix+0)
	ld h,(ix+1)
	ld e,(ix+2)
	ld d,(ix+3)
	dec ix
	dec ix
	dec ix
	dec ix
	ld (pos_cola),ix
	
	ld hl,elementos_cola
	dec (hl)
ei
	ret

.elementos_cola defw 0
.pos_cola defw cola_impresion
;pos_escritura_cola defw cola_impresion
.cola_impresion defs 12

.bucle_texto0
ld a,1
ld (imprimiendo),a

ld a,(first_char)
ld b,a		;resto 48 para saber el número del caracter (En ASCII 0=48)

ld a,(hl)
or a ;cp 0
ret z
sub b
ld bc,cpc_Chars	;apunto a la primera letra
push hl


ld l,a		;en A tengo la letra que sería
ld h,0
add hl,hl
add hl,hl
add hl,hl	;x8 porque cada letra son 8 bytes
add hl,bc	;ahora HL apunta a los datos de la letra correspondiente

call escribe_letra
ld hl,(direcc_destino)
inc hl

ld (direcc_destino),hl
ld de,letra_decodificada
;ld A,8	;alto  
call cpc_PutSp0


pop hl
inc hl
jp bucle_texto0
.imprimiendo defb 0
.direcc_destino defw 0


.cpc_PutSp0
		defb $fD
   		LD H,8		;ALTO, SE PUEDE TRABAJAR CON HX DIRECTAMENTE
		ld b,7
		ld c,b
	.loop_alto_2

	.loop_ancho_2		
		ex de,hl
		ldi
		;ldi
		
	   defb $fD
	   dec H
	   ret z	
	   ex de,hl   	   
.salto_linea
		LD C,$ff			;&07f6 			;salto linea menos ancho
		ADD HL,BC
		jp nc,loop_alto_2 ;sig_linea_2zz		;si no desborda va a la siguiente linea
		ld bc,$c050
		add HL,BC
		ld b,7			;sólo se daría una de cada 8 veces en un sprite
		jp loop_alto_2	
		
		
		
.escribe_letra
ld iy,letra_decodificada
ld b,8
.bucle_alto
push bc
push hl

ld a,(hl)
ld hl,dato
ld (hl),a
;call rutina	;me deja en ix los valores convertidos


;.rutina
;HL tiene la dirección origen de los datos de la letra
;LD DE,letra	;el destino es la posición de decodificación de la letra
;Se analiza el byte por parejas de bits para saber el color de cada pixel.
ld ix,byte_tmp	
ld (ix+0),0

LD B,4	;son 4 pixels por byte. Los recorro en un bucle y miro qué color tiene cada byte.
.bucle_colores
;roto el byte en (HL)
push hl
call op_colores_m1	;voy a ver qué color es el byte. tengo un máximo de 4 colores posibles en modo 0.
pop hl
sla (HL)	
sla (HL)	;voy rotando el byte para mirar los bits por pares.

djnz bucle_colores
;inc ix
;ret



;xor a
ld a,(ix+0)
;or (ix-3)
;or (ix-4)
ld (iy+0),a
inc iy
pop hl
inc hl
pop bc
djnz bucle_alto
ret


;.rutina
;HL tiene la dirección origen de los datos de la letra

;Se analiza el byte por parejas de bits para saber el color de cada pixel.
;ld ix,byte_tmp	
;ld (ix+0),0

;LD B,4	;son 4 pixels por byte. Los recorro en un bucle y miro qué color tiene cada byte.
;.bucle_colores
;roto el byte en (HL)
;push hl
;call op_colores_m1	;voy a ver qué color es el byte. tengo un máximo de 4 colores posibles en modo 0.
;pop hl
;sla (HL)	
;sla (HL)	;voy rotando el byte para mirar los bits por pares.

;djnz bucle_colores

;ret
.op_colores_m1   ;rutina en modo 1
					;mira el color del bit a pintar
LD A,@11000000		;hay 4 colores posibles
AND (HL)
CP @11000000
JP Z, c3_m1
AND (HL)
CP @10000000
JP Z, c2_m1
AND (HL)
CP @01000000
JP Z, c1_m1
AND (HL)
CP @00000000
;JP Z, c0
.c0_m1
;LD A,0
xor a
;JP cont_color

.cont_color_m1   ;dependiendo del bit a pintar hay 4 posiciones diferentes
;//miro si estoy haciendo un pixel par o impar. De cada byte original generaré 2.

ld hl,colores_m1		;mira el byte
ld d,0
ld e,a
add hl,de
;de apunta al byte
ld c,(hl)
;En C está el byte del color
;Se rota 4-b veces
;tengo el byte del color en la memoria
;lo roto 4-b veces
ld a,4
sub b
or a ;cp 0
jp z,_sin_rotar
.rotando
srl c
dec a
jp nz, rotando
._sin_rotar

ld a,c
or (ix+0)
ld (ix+0),a
;inc ix
ret




.c3_m1	;indico el número de color
LD A,3
JP cont_color_m1
.c2_m1
LD A,2
JP cont_color_m1
.c1_m1
LD A,1
JP cont_color_m1




.dato defb @00011011  ;aquí dejo temporalmente el byte a tratar

.byte_tmp defs 2
.colores_m1 
defb 0,@10001000,@10000000,@00001000

;defb @00000000,  @01010100, @00010000, @00000101  ;@00000001, @00000101, @00010101, @00000000

.letra_decodificada defs 8	;uso este espacio para guardar la letra que se decodifica


DEFC direcc_destino0_m1 = direcc_destino
DEFC colores_cambM1 = colores_m1