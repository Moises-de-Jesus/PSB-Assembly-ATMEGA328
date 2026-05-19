;
; AssemblerApplication6.asm
;
; Created: 18/05/2026 23:52:27
; Author : moise
;


; Replace with your application code
.nolist
.include "m328Pdef.inc"
.list

.equ BOTAO = PB0
.equ DISPLAY1 = PORTD
.equ DISPLAY2 = PORTC
.def AUX = R16
.def AUXE = R20
.ORG 0x000

Inicializacao:
	LDI AUX,0b11111110
	OUT DDRB, AUX
	LDI AUX,0xFF
	LDI AUXE, 0x00
	OUT PORTB,AUX
	OUT DDRD,AUX
	OUT DDRC, AUX
	OUT PORTC,AUX
	OUT PORTD, AUX
	STS UCSR0B,R1
Principal:
	SBIC PINB,BOTAO
	RJMP Principal
	CPI AUX, 0x09
	BRNE Incr1
	CPI AUXE,0x05
	BRNE Incr2
	CPI AUX,0x09
	BRNE Incr1
	LDI AUXE,0x00
	LDI AUX,0x00
	RJMP Decod
Incr1:
	INC AUX
	RJMP Decod
Incr2:
	INC AUXE
	LDI AUX,0x00
Decod:
	RCALL Decodifica1
	RCALL Decodifica2
	RCALL Atraso
	RJMP Principal
Atraso:
	LDI R19,16
volta:
	DEC R17
	BRNE volta
	DEC R18
	BRNE volta
	DEC R19
	BRNE volta
	RET
Decodifica1:
	LDI ZH,HIGH(Tabela<<1)
	LDI ZL,LOW(Tabela<<1)
	ADD ZL,AUX
	BRCC le_tab1
	INC ZH
le_tab1:
	LPM R0,Z
	OUT DISPLAY1,R0
	RET
Decodifica2:
	LDI ZH,HIGH(Tabela<<1)
	LDI ZL,LOW(Tabela<<1)
	ADD ZL,AUXE
	BRCC le_tab2
	INC ZH
le_tab2:
	LPM R0,Z
	OUT DISPLAY2,R0
	RET
Tabela: .dw 0x7940, 0x3024, 0x1219, 0x7802,0x1800,0x0308,0x2146,0x0E06