	AREA My_Constants, CODE, READONLY
	THUMB
		
	;defining addresses here for practice

;general base addresses
AHB_PORTB	EQU 0x40059000
AHB_PORTA	EQU	0x40058000
SYS_CONTROL	EQU 0x400FE000
SYS_PERIPH	EQU 0xE000E000
TIMER16_0	EQU	0x40030000
TIMER16_4	EQU	0x40034000
UART0		EQU	0x4000C000
	
;offsets
	;RCGC Run-time offsets
RCGCGPIO	EQU	0x608
RCGCTIMER	EQU 0x604
RCGCUART	EQU	0x618
	;GPIO offsets
GPIOHBCTL 	EQU 0x06C
GPIOCTL		EQU	0x52C
GPIODIR		EQU	0X400
GPIOAFSEL	EQU	0X420
GPIODR2R	EQU	0X500
GPIOPUR		EQU	0X510
GPIODEN		EQU	0X51C
GPIOPCTL	EQU 0x52C
GPIODATAPB5	EQU	0x3FC;0X080
	;SysTick offsets
STCTRL		EQU	0X010
STRELOAD	EQU	0X014
STCURRENT	EQU	0X018	
SYSPRI3		EQU	0XD20
	;NVIC offsets
NVIC_ENn	EQU	0x100
NVIC_DISn	EQU	0x180
NVIC_PRIn	EQU	0x440
	;Timer offsets
GPTMCTL		EQU	0x00C
GPTMCFG		EQU	0x000
GPTMTAMR	EQU	0x004
GPTMTBMR	EQU	0x008
GPTMTAILR	EQU	0x028
GPTMTBILR	EQU	0x02C
GPTMTAPR	EQU	0x038
GPTMTBPR	EQU	0x03C
GPTMIMR		EQU	0x018
GPTMRIS		EQU	0x01C
GPTMICR		EQU	0x024
GPTMTAV		EQU	0X050
GPTMTBV		EQU	0x054
GPTMTAR		EQU 0x048
GPTMTBR		EQU	0x04C
GPTMMIS		EQU	0x020
	;UART offsets
UARTCC		EQU	0xFC8
UARTCTL		EQU	0x030
UARTIBRD	EQU	0x024
UARTFBRD	EQU	0x028
UARTLCRH	EQU	0x02C
UARTFR		EQU	0x018
UARTRSR		EQU 0x004
UARTIFLS	EQU	0x034
UARTRIS		EQU	0x03C
UARTIM		EQU	0x038
UARTMIS		EQU	0x040
UARTICR		EQU	0x044
UARTDR		EQU	0x000
	
;FIFO constants
	ALIGN 2
SIZE	DCW 16
SUCCESS	DCW 1
FAIL	DCW 0
	
	END