;
; AssemblerApplication3.asm
;
; Created: 24/04/2026 15:04:06
; Author : moise
;


;
; AssemblerApplication2.asm
;
; Created: 10/04/2026 15:50:25
; Author : moise
;

.nolist
.include "m328Pdef.inc"
.list

.equ LED0 = PB0
.equ LED1 = PB1
.equ LED2 = PB2
.equ LED3 = PB3
.equ BOTAO1 = PD5
.equ BOTAO2 = PD7
.def AUX = R16
.def COUNT = R17
.ORG 0x000
Inicializacoes:
	LDI COUNT,0b11111111
	LDI AUX,0b11111111
	OUT DDRD,AUX
	OUT DDRB,AUX
	OUT PORTD,AUX
	LDI AUX,0x00
	OUT PORTB,AUX
	NOP 
Principal:
	RCALL Apertar1
	RCALL Apertar2
	RJMP Principal
Apertar1:
	SBIC PIND,BOTAO1
	RET
	Esp_Soltar1:
		SBIS PIND,BOTAO1 
		RJMP Esp_Soltar1
	RCALL Atraso
	RJMP CONTAGEM
Apertar2:
	SBIC PIND,BOTAO2
	RET
	Esp_Soltar2:
		SBIS PIND,BOTAO2
		RJMP Esp_Soltar2
	RCALL Atraso
	RJMP DECONTAGEM
CONTAGEM:
	OUT PORTB,COUNT
	RCALL AtrasoM
	INC COUNT
	RCALL Apertar2
	RJMP CONTAGEM
DECONTAGEM:
	OUT PORTB,COUNT
	RCALL AtrasoM
	DEC COUNT
	RCALL Apertar1
	RJMP DECONTAGEM
Atraso:
	DEC R6
	BRNE Atraso
	DEC R1
	BRNE Atraso
	RET
AtrasoM:
	DEC R5
	DEC R5
	BRNE AtrasoM
	DEC R2
	DEC R2
	BRNE AtrasoM
	DEC R3
	DEC R3
	BRNE AtrasoM
	RET
