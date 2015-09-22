
#ifndef  __cpcrslib_h__
#define __cpcrslib_h__


void 						cpc_SetMode( char color) __z88dk_fastcall;
void 						cpc_SetModo( char x) __z88dk_fastcall;
void 						cpc_SetColour(unsigned char num,  char color) __z88dk_callee;
void  						cpc_SetInk(unsigned char num,  unsigned char color) __z88dk_callee;
void  						cpc_SetBorder( char color) __z88dk_fastcall;
void 						cpc_ClrScr(void);


void 						cpc_PrintStr(char *text) __z88dk_fastcall;
unsigned char 				cpc_Random(void);
void						cpc_EnableFirmware(void);
void						cpc_DisableFirmware(void);



#endif /* __cpcrslib_h__ */
