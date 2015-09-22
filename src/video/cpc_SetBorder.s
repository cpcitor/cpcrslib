.module video

.globl _cpc_SetBorder

_cpc_SetBorder::

	LD B,l
	LD C,B
	JP 0XBC38