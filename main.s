	;Include constants I define to main	
	;INCLUDE my_Constants.s	
	;Include subroutines I define to main
	INCLUDE my_Subroutines.s
	
	AREA |.text|, CODE, READONLY
	THUMB
	EXPORT __main
	ENTRY
	
__main	PROC
	
	;Setup clocks for GPIO, GPTM, and UART at run-time
	BL RCGC_Init
	
	;Setup GPIO first
	BL GPIO_Init
	
	;Setup GPIO PB0&PB1 for UART1
	BL GPIO_UART1
	
	;Setup priority level for UART1
	MOV r0, #6; UART1 is IRQn = 6
	MOV r1, #1 ;priority #1
	BL NVIC_Priority
	
	;Enable UART1 interrupt
	MOV r0, #6; UART1 is IRQn = 6
	MOV r1, #1; r1 = 1: Enable
	BL NVIC_Init
	
	;Setup UART
	BL UART_Init
	
	
	
	;;Writing data to UARTDR for debugging
	;;Write a '??' character to send at time out
	;LDR r0, =UART1
	
	;;The '?' character
	;MOV r1,#0x3F
	
	;;Write '??' to UARTDR
	;STR r1,[r0, #UARTDR]
	
	
	
while
	
	B while
	
	ENDP
		
	END