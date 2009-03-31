
XLIB cpc_ScrollRight0





XREF tiles
XREF ancho_pantalla_bytes 
XREF rightColumnScr
XREF alto_pantalla_bytes
XREF pantalla_juego
XREF posiciones_pantalla

.cpc_ScrollRight0
ld hl,pantalla_juego+alto_pantalla_bytes*ancho_pantalla_bytes/16-1
ld de,pantalla_juego+alto_pantalla_bytes*ancho_pantalla_bytes/16
ld bc,alto_pantalla_bytes*ancho_pantalla_bytes/16 ;-1
LDDR
RET