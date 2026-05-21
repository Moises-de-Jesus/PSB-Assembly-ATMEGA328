;
; AssemblerApplication8.asm
;
; Created: 19/05/2026 17:36:39
; Author : moise
;
.nolist
.include "m328Pdef.inc"
.list

.equ BOTAO1 = PB0
.equ BOTAO2 = PB1
.equ BOTAO3 = PB2
.equ DISPLAY1 = PORTD
.equ DISPLAY2 = PORTC
.def AUX = R16
.def DEZ = R23
.def AUXE = R20
.ORG 0x000

Inicializacao:
	LDI AUX,0b11111000
	LDI DEZ,0x0A
	LDI AUXE, 0x00
	OUT DDRB, AUX
	LDI AUX,0xFF
	OUT PORTB,AUX
	OUT DDRD,AUX
	OUT DDRC, AUX
	OUT PORTC,AUX
	OUT PORTD, AUX
	STS UCSR0B,R1
Principal:
	SBIS PINB, BOTAO1
	RJMP Contagemback
	SBIS PINB, BOTAO2
	RJMP Decontagemback
	SBIS PINB, BOTAO3
	RJMP ContagemTriplaback
	RJMP Principal
Contagemback:
	SBIS PINB, BOTAO1
	RJMP Contagemback
Contagem:
	SBIS PINB, BOTAO2
	RJMP Decontagemback
	SBIS PINB, BOTAO3
	RJMP ContagemTriplaback
	CPI AUX, 0x09
	BRNE Incr1
	CPI AUXE, 0x05
	BRNE IncrE1
	RJMP Contagem
Decontagemback:
	SBIS PINB, BOTAO2
	RJMP Decontagemback
Decontagem:
	SBIS PINB, BOTAO1
	RJMP Contagemback
	SBIS PINB, BOTAO3
	RJMP ContagemTriplaback
	CPI AUX, 0x00
	BRNE Incr2
	CPI AUXE, 0x00
	BRNE DecrE
	RJMP Decontagem
ContagemTriplaback:
	SBIS PINB, BOTAO3
	RJMP ContagemTriplaback
ContagemTripla:
	SBIS PINB, BOTAO1
	RJMP Contagemback
	SBIS PINB, BOTAO2
	RJMP Decontagemback
	RJMP Incr3
	RJMP ContagemTripla
Incr1:
	INC AUX
	RCALL Decod
	RJMP Contagem
Incr2:
	DEC AUX
	RCALL Decod
	RJMP Decontagem
Incr3:
	INC AUX
	INC AUX
	INC AUX
	INC AUX
	CPI AUX, 0x09
	BRLO continue
	CPI AUXE,0x05
	BRNE IncrE2
	LDI AUX,0x09
	continue:
	RCALL Decod
	RJMP ContagemTripla
IncrE1:
	INC AUXE
	LDI AUX,0x00
	RCALL Decod
	RJMP Contagem
IncrE2:
	INC AUXE
	SUB AUX, DEZ
	RCALL Decod
	RJMP ContagemTripla
DecrE:
	DEC AUXE
	LDI AUX,0x09
	RCALL Decod
	RJMP Decontagem
Decod:
	RCALL Decodifica1
	RCALL Decodifica2
	RCALL Atraso
	RET
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
AtrasoS:
	DEC R5
	BRNE volta
	DEC R6
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


