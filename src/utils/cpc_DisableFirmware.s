.module utils

.include "Firmware.s"

.globl _cpc_DisableFirmware

_cpc_DisableFirmware::
	DI
	
	LD HL,(#0X0038)
	LD (#_backup_fw),HL

	LD HL,#0XC9FB		;EI
	LD (#0X0038),HL

	EI
	RET
	
_backup_fw:: .DW  #0	