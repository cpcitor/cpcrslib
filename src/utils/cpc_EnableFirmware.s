.module utils

.include "firmware.s"

.globl 	_cpc_EnableFirmware

_cpc_EnableFirmware::
	DI
	LD HL,(_backup_fw)
	LD (#0X0038),HL			;EI
	;INC HL
	;LD (HL),D			;RET
	EI
	RET