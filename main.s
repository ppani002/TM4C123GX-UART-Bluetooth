	;Include constants I define to main	
	;INCLUDE my_Constants.s	
	;Include subroutines I define to main
	INCLUDE my_Subroutines.s
	
	AREA |.text|, CODE, READONLY
	THUMB
	EXPORT __main
	ENTRY
	
__main	PROC
	
	;Setup clocks for GPIO and GPTM at run-time
	BL RCGC_Init
	
	;Setup GPIO first
	BL GPIO_Init
	
	;Setup GPIO PA0&PA1 for UART
	BL GPIO_UART1
	
	;Setup priority level for UART0
	MOV r0, #6; UART0 is IRQn = 19
	MOV r1, #1 ;priority #1
	BL NVIC_Priority
	
	;Enable UART0 interrupt
	MOV r0, #6; UART0 is IRQn = 19
	MOV r1, #1; r1 = 1: Enable
	BL NVIC_Init
	
	;Setup UART
	BL UART_Init
	
	
while
	
	B while
	
	ENDP
		
	END