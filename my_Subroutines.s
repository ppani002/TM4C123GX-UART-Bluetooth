	;Include constants here
	INCLUDE my_Constants.s
	;Include variables here
	IMPORT PB5_MASK
	IMPORT TxPutI
	IMPORT TxGetI
	IMPORT TxFifo
	IMPORT RxPutI
	IMPORT RxGetI
	IMPORT RxFifo

	AREA My_Subroutines, CODE, READONLY
	THUMB

;This subroutine initiates the NVIC interrupt for the provided interrupt number
;Input arguments:
;	r0: IRQn
;	r1: 1 = Enable, 0 = Disable
NVIC_Init	PROC
	PUSH {r4, LR} ;Push context onto stack
	
	AND r2, r0, #0x1F	;Bitoffset
	MOV r3, #1
	LSL r3, r3, r2 ;Shift enable/disable bit to correct bit position
	LDR r4, =SYS_PERIPH ;NVIC base address
	
	CMP r1, #0 ;Want to enable to disable?
	LDRNE r1, =NVIC_ENn
	LDREQ r1, =NVIC_DISn
	
	ADD r1, r4, r1 ;add offset to base address
	LSR r2, r0, #5 ;find register number n. IRQn/32
	LSL r2, r2, #2 ;Wordoffset with 0 extend. Finds register n address
	
	STR r3, [r1, r2]
	
	POP {r4,LR}
	BX LR
	
	ENDP

;This subroutine sets the priority level for the provided interrupt number
;Input Arguments:
;	r0: IRQn
;	r1: Priority level 0~7
NVIC_Priority	PROC
	PUSH {r4, LR} ;Push context onto stack
	
	AND r2, r0, #0x03 ;Bitoffset for TBB (case index)
	
	LDR r3, =SYS_PERIPH
	LDR r4, =NVIC_PRIn
	ADD r3, r3, r4
	LSR r4, r0, #2 
	LSL r4, r4, #2
	
	;TBB might only work in THUMB2 
	TBB [PC, r2]

BranchTable
	DCB (Case_0 - BranchTable)/2 ;index 0: Case_0
	DCB (Case_1 - BranchTable)/2 ;index 1: Case_1
	DCB (Case_2 - BranchTable)/2 ;index 2: Case_2
	DCB (Case_3 - BranchTable)/2 ;index 3: Case_3
	ALIGN
		
Case_0
	LSL r1, r1, #5 ;Shift to [7:5]
	B exit
Case_1
	LSL r1, r1, #13 ;Shift to [15:13]
	B exit
Case_2
	LSL r1, r1, #21 ;Shift to [23:21]
	B exit
Case_3
	LSL r1, r1, #29 ;Shift to [31:29]
	B exit
	
exit
	STR r1, [r3, r4]
	
	POP {r4,LR}
	BX LR
	
	ENDP
	
	
;This subroutine initializes GPIO for external LED. Also sets GPIO to AHB	
GPIO_Init	PROC
	;Save context
	PUSH {LR}
	
	;select AHB. GPIOHBCTL
	LDR r0, =SYS_CONTROL
	LDR r1,[r0, #GPIOHBCTL]
	ORR r1, r1, #(1<<1) ;Enable port B AHB instead. "Note that GPIO can only be accessed through the AHB aperture
	STR r1,[r0, #GPIOHBCTL]
	
	;set to output. GPIODIR
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODIR]
	ORR r1, r1, #(1<<5);pin5
	STR r1,[r0,#GPIODIR]
	
	;set mode to GPIO (nor alternate function). GPIOAFSEL
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIOAFSEL]
	BFC r1,#0,#8 ;clears fields. 0 = GPIO
	STR r1,[r0,#GPIOAFSEL]
	
	;to drive strength to 2mA. GPIODR2R
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODR2R]
	ORR r1, r1, #(1<<5);pin5
	STR r1,[r0,#GPIODR2R]
	
	;set to pull up. GPIOPUR
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIOPUR]
	ORR r1, r1, #(1<<5) ;pin5
	STR r1,[r0,#GPIOPUR]
	
	;enable digital output. GPIODEN
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODEN]
	ORR r1,r1, #(1<<5);pin 1 = digital output enable
	STR r1,[r0,#GPIODEN]
	
	;write "high" to data register for port B pin 5 to turn on red LED. GPIODATA
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODATAPB5]
	LDR r2, =PB5_MASK	;get RAM address of PB5 mask (pointer)
	LDR r3,[r2]	;get the value of PB5 mask
	ORR r1, r1, r3	;Set PB5 to 'high'
	STR r1,[r0,#GPIODATAPB5]
	
	;Restore context
	POP {LR}
	BX LR
	ENDP
		
		
;This subroutine sets up GPIO pins PB0 (Rx) & PB1 (Tx) for UART1
GPIO_UART1	PROC
	;Save context
	PUSH {LR}
	
	;set to output. GPIODIR
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODIR]
	ORR r1, r1, #1 ;PB0: input
	BFC r1, #1, #1 ;PB1: output
	STR r1,[r0,#GPIODIR]
	
	;set mode to GPIO (nor alternate function). GPIOAFSEL
	LDR r0, =AHB_PORTB
	LDR r1,[r0, #GPIOAFSEL]
	ORR r1, r1, #1 ;PB0: AF
	ORR r1, r1, #(1<<1) ;PB1: AF
	STR r1,[r0, #GPIOAFSEL]
	
	;Select UART for AF
	LDR r0, =AHB_PORTB
	LDR r1,[r0, #GPIOPCTL]
	ORR r1, r1, #0x1 ;PB0: UART
	ORR r1, r1, #(0x1<<4) ;PB1: UART
	STR r1,[r0, #GPIOPCTL]

	;to drive strength to 2mA. GPIODR2R
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODR2R]
	ORR r1, r1, #1 ;PB0: 2mA
	ORR r1, r1, #(1<<1) ;PB1: 2mA
	STR r1,[r0,#GPIODR2R]
	
	;enable digital output. GPIODEN
	LDR r0, =AHB_PORTB
	LDR r1,[r0,#GPIODEN]
	ORR r1, r1, #1 ;PB0: Digital I/O
	ORR r1, r1, #(1<<1) ;PB1: Digital I/O
	STR r1,[r0,#GPIODEN]
	
	;Restore context
	POP {LR}
	BX LR
	ENDP		
		
		
		
;Initializes RCGC for GPIO and Timer0 at run-time
RCGC_Init	PROC
	;Save context
	PUSH {LR}
	
	;Initialize Timer0 for run-time via RCGC
	LDR r0, =SYS_CONTROL
	LDR r1,[r0, #RCGCTIMER]
	BFC r1,#0,#6 ;clear fields [5:0]
	ORR r1, r1, #1 ;R0 = 1: enable Timer0
	STR r1,[r0, #RCGCTIMER]
	
	
	;Initialize GPIO PortB for run-time via RCGC
	;Enable clock. RCGCGPIO
	LDR r0, =SYS_CONTROL 
	LDR r1,[r0,#RCGCGPIO]
	ORR r1, r1, #(1<<1) ;enable port B clock(bit 5)
	STR r1,[r0,#RCGCGPIO]
	
	;Initialize UART for run-time via RCGC
	LDR r0, =SYS_CONTROL
	LDR r1,[r0, #RCGCUART]
	ORR r1,r1,#(1<<1) ;bit 1 (UART1), not bit 0 (UART0)
	STR r1,[r0, #RCGCUART]
	
	;Restore context
	POP {LR}
	BX LR
	ENDP
		

;This subroutine initialies SysTick
SysTick_Init	PROC
	
	;Push LR onto stack first
	PUSH {LR}
	
	;Clear ENABLE bit. STCTRL
	LDR r0, =SYS_PERIPH
	LDR r1, [r0,#STCTRL]
	AND r1, r1, #0	;Clear bit 0
	STR r1, [r0, #STCTRL]
	
	;Set reload value. STRELOAD
	LDR r0, =SYS_PERIPH
	LDR r1, [r0,#STRELOAD]
	ORR r1, r1, #(1<<5);23) ;Set interrupt period here
	STR r1, [r0,#STRELOAD]
	
	;Clear timer and interrupt flag. STCURRENT
	LDR r0, =SYS_PERIPH
	LDR r1, [r0,#STCURRENT]
	ORR r1, r1, #1 ;Write any value to reset
	STR r1, [r0,#STCURRENT]
	LDR r1, [r0,#STCURRENT]
	
	;Set CLK_SRC bit to use the system clock (PIOSC). STCTRL
	LDR r0, =SYS_PERIPH
	LDR r1, [r0,#STCTRL]
	ORR r1, r1, #(1<<2) ;bit 2
	STR r1, [r0,#STCTRL]
	
	;Set INTEN bit to enable interrupts. STCTRL
	LDR r0, =SYS_PERIPH
	LDR r1, [r0,#STCTRL]
	ORR r1, r1, #(1<<1) ;bit 1
	STR r1, [r0,#STCTRL]
	
	;Set ENABLE bit to turn SysTick on again. STCTRL
	
	
	;Set TICK priority field. SYSPRI3
	LDR r0, =SYS_PERIPH
	LDR r1, [r0,#SYSPRI3]
	ORR r1, r1, #(1<<29) ;priority 1. TICK begins at bit 29
	STR r1, [r0,#SYSPRI3]
	
	;Set ENABLE bit to turn SysTick on again. STCTRL
	LDR r0, =SYS_PERIPH
	LDR r1, [r0,#STCTRL]
	ORR r1, r1, #1 ;bit 0
	STR r1, [r0,#STCTRL]
	
	
	;Pop LR and return to __main
	POP {LR}
	BX LR
	
	ENDP


;Specifically for Timer0. Generalize this function		
TIMER_Init	PROC
	;Save context
	PUSH {LR}
	
	;Disable Timer0A
	LDR r1, =TIMER16_0
	LDR r2,[r1, #GPTMCTL]
	BFC r2,#0,#1 ;clear TAEN to disable Timer0A
	STR r2,[r1, #GPTMCTL]
	
	;Concatanate withh 0x0. Seperate with 0x4
	LDR r1, =TIMER16_0
	LDR r2,[r1, #GPTMCFG]
	BFC r2,#0,#3 ;Clear bits
	ORR r2, r2, #0x0 ;Concatanate timers
	STR r2,[r1, #GPTMCFG]
	
	;Configure Timer mode
	LDR r1, =TIMER16_0
	LDR r2,[r1, #GPTMTAMR]
	
	;No snapshot mode
	BFC r2,#7,#1 
	
	;Disable interrupts when counter == CCR
	BFC r2,#5,#1 
	;ORR r2,r2,#(1<<5);Enable interrupts when counter == CCR
	
	;count down
	BFC r2,#4,#1 
	
	;Set periodic mode
	BFC r2,#0,#2
	ORR r2, r2,#(0x2)
	STR r2,[r1, #GPTMTAMR]
	
	;Set ARR value
	LDR r1, =TIMER16_0
	LDR r2,[r1, #GPTMTAILR]
	BFC r2,#0,#32 ;
	MOV r2,#0x00FFFFFF ;#0x3E42
	STR r2,[r1, #GPTMTAILR]
	
	;Set Prescale value
	LDR r1, =TIMER16_0
	LDR r2,[r1, #GPTMTAPR]
	BFC r2,#0,#8
	;ORR r2,r2,#0xFF
	STR r2,[r1, #GPTMTAPR]
	
	;Set interrupts at timeout
	LDR r1, =TIMER16_0
	LDR r2,[r1, #GPTMIMR]
	BFC r2,#0,#1
	ORR r2,r2,#1;Enable interrupts at timeout
	STR r2,[r1, #GPTMIMR]

	;Prevents Timer0A from freezing during debug
	LDR r1, =TIMER16_0
	LDR r2,[r1, #GPTMCTL]
	BFC r2,#9,#1
	ORR r2,r2,#(1<<9) ;Set TASTAL to 1 to prevent stopping during debug
	BFC r2,#4,#1
	ORR r2,r2,#(1<<4) ;Set RCTEN to 1 to prevent stopping during debug
	STR r2,[r1, #GPTMCTL]
	
	;Enable Timer0A
	LDR r1, =TIMER16_0
	LDR r2,[r1, #GPTMCTL]
	BFC r2,#0,#1 
	ORR r2,r2,#1 ;Set TAEN to enable Timer0A
	STR r2,[r1, #GPTMCTL]
	
	;Restore context
	POP {LR}
	BX LR
	ENDP
		
		
;This subroutine initializes UART1, Tx = PB1 & Rx = PB0
UART_Init	PROC
	;Save context
	PUSH {LR}
	
	;Disable UART
	LDR r0, =UART1
	LDR r1,[r0, #UARTCTL] ;Program hangs here if I read. Just write instead
	
	;Set LBE bit for debugging
	ORR r1,r1,#(1<<7)
	
	;Clear UART enable bit
	BFC r1,#0,#1
	
	;ClkDiv = 16
	BFC r1,#5,#1
	
	;Disable Rx and Tx
	BFC r1,#8,#1
	BFC r1,#9,#1
	
	STR r1,[r0, #UARTCTL]
	
	;BRD. Baud Rate by default (?) is 9600.
	;Write BRDI. 104 decimal
	LDR r0, =UART1
	LDR r1,[r0, #UARTIBRD]
	BFC r1,#0,#16
	ORR r1,r1, #0x68
	STR r1,[r0, #UARTIBRD]
	
	;Write BRDF. 11 decimal
	LDR r0, =UART1
	LDR r1,[r0, #UARTFBRD]
	BFC r1,#0,#6
	ORR r1,r1, #0xB
	STR r1,[r0, #UARTFBRD]
	
	;Configure Frame and save BRD via UARTLCRH
	LDR r0, =UART1
	LDR r1,[r0, #UARTLCRH]
	BFC r1,#0,#7
	
	;8 bits data
	ORR r1,r1,#(0x3<<5)
	
	;Enable hardware FIFOs
	ORR r1,r1,#(1<<4)
	
	STR r1,[r0, #UARTLCRH]
	
	;Choose clock for UART
	LDR r0, =UART1
	LDR r1,[r0, #UARTCC]
	BFC r1,#0,#3
	ORR r1, r1, #0x5 ;PIOSC, 16MHz
	STR r1,[r0, #UARTCC]
	
	;Choose FIFO trigger levels
	LDR r0, =UART1
	LDR r1,[r0, #UARTIFLS]
	BFC r1,#0,#6
	
	;RxFIFO>=1/8. 16bytes/8 = 2 bytes
	ORR r1,r1,#(0x0<<3)
	
	;TxFIFO<=1/8. 16bytes/8 = 2 bytes
	ORR r1,r1,#0x4 
	
	STR r1,[r0, #UARTIFLS]
	
	;Choose interrupts to enable to NVIC
	LDR r0, =UART1
	LDR r1,[r0, #UARTIM]
	BFC r1,#4,#3
	
	;Allow timeout interrupt
	ORR r1,r1,#(1<<6)
	
	;Allow TxFIFO interrupt
	ORR r1,r1,#(1<<5)
	
	;Allow RxFIFO interrupt
	ORR r1,r1,#(1<<4)
	
	STR r1,[r0, #UARTIM]
	
	;Enable UART
	LDR r0, =UART1
	LDR r1,[r0, #UARTCTL]
	
	;Enable Rx
	ORR r1,r1,#(1<<9)
	
	;Enable Tx
	ORR r1,r1,#(1<<8)
	
	;Enable UART
	ORR r1,r1,#1
	
	STR r1,[r0, #UARTCTL]
	
	;Restore context
	POP {LR}
	BX LR
	
	ENDP
		
		
		
;This subroutine is used to push data onto software FIFO
;Input parameters
;	r0: 0/1 = Tx/Rx
;	r1: 8-bit data value
Push_FIFO	PROC
	;Push context
	PUSH {r4,r5,r6,r7,r8,r9,r10,r11} ;Remove registers that aren't used from list

	;Are you using TxFIFO or RxFIFO?
	CMP r0,#0
	BNE Push_RxFIFO

Push_TxFIFO
	;Note: Loading variables from memory like this means it's static - it remains even after leaving the subroutine and is only visible to where it's called (at assembly level)
	;Load Tx counters. Volatile
	LDR r0, =TxPutI
	LDR r2,[r0]
	LDR r0, =TxGetI
	LDR r3,[r0]
	;Load FIFO
	LDR r4, =TxFifo

	B Push_cont

Push_RxFIFO
	;Load Rx counters. Volatile
	LDR r0, =RxPutI
	LDR r2,[r0]
	LDR r0, =RxGetI
	LDR r3,[r0]
	;Load FIFO
	LDR r4, =RxFifo

Push_cont
	;Setup
	LDR r0, =SIZE
	;LDRH for unsigned halfward (16 bits)
	LDRH r5,[r0]
	SUB r5,r5,#1 ;SIZE-1
	
	MVN r6,r5 ;~SIZE
	SUB r3,r2,r3 ;don't need GetI anymore. Reuse r2
	AND r3,r3,r6 ;(PutI - GetI) & ~(SIZE - 1)

	;If software FIFO is full, return FAIL and exit. Otherwise continue
	CMP r3,#0
	BEQ Push_exit

	;This part is used to index. This is a little more difficult, depending on how far apart the data actually is in the array. Since array is DCB, 8 bits -> no offset?
	AND r2,r2,r5 ;PutI & (SIZE - 1)
	;STRH for unsigned byte
	STRH r1,[r4,r2] ;Fifo[base+offset+memOffset], memOffset is offset caused by memory (4 locations for 32 bits, etc0. Since DCB is 8, it's assumed that memOffset = 0
	LDR r1, =SUCCESS
	;LDRH for unsigned halfward (16 bits)
	LDRH r0,[r1] ;Return SUCCESS value

	;Restore context
	POP {r4,r5,r6,r7,r8,r9,r10,r11} ;Remove registers that aren't used from list

	BX LR

Push_exit
	LDR r1, =FAIL
	;LDRH for unsigned halfward (16 bits)
	LDRH r0,[r1] ;Return FAIL value

	;Restore context
	POP {r4,r5,r6,r7,r8,r9,r10,r11} ;Remove registers that aren't used from list
	
	BX LR

	ENDP

;This subroutine is used to pull data from software FIFO
;Input arguments
;	r0: 0/1 = Tx/Rx
;	r1: Address of temporary variable (? It can be a register too. To write to a variable)
Pull_FIFO	PROC
	;Push context
	PUSH {r4,r5,r6,r7,r8,r9,r10,r11} ;Remove registers that aren't used from list

	;Are you using TxFIFO or RxFIFO?
	CMP r0,#0
	BNE Pull_RxFIFO

Pull_TxFIFO
	;Load Tx counters
	LDR r0, =TxPutI
	LDR r2,[r0]
	LDR r0, =TxGetI
	LDR r3,[r0]
	;Load FIFO
	LDR r4, =TxFifo

	B Pull_cont

Pull_RxFIFO
	;Load Rx counters
	LDR r0, =RxPutI
	LDR r2,[r0]
	LDR r0, =RxGetI
	LDR r3,[r0]
	;Load FIFO
	LDR r4, =RxFifo

Pull_cont
	;setup
	LDR r0, =SIZE
	;LDRH for unsigned halfward (16 bits)
	LDRH r5,[r0]
	SUB r5,r5,#1 ;SIZE-1

	;If software FIFO is empty, return FAIL and exit. Otherwise continue
	CMP r2,r3
	BEQ Pull_exit

	;This part is used to index. This is a little more difficult, depending on how far apart the data actually is in the array. Since array is DCB, 8 bits -> no offset?
	AND r3,r3,r5 ;GetI & (SIZE - 1)
	;LDRB for unsigned byte
	LDRB r2,[r4,r3] ;Fifo[base+offset+memOffset], memOffset is offset caused by memory (4 locations for 32 bits, etc0. Since DCB is 8, it's assumed that memOffset = 0
	;STRH for unsigned byte
	STRH r2,[r1] ; *data = Fifo[n]
	LDR r1, =SUCCESS
	;LDRH for unsigned halfward (16 bits)
	LDRH r0,[r1] ;Return SUCCESS value

	;Restore context
	POP {r4,r5,r6,r7,r8,r9,r10,r11} ;Remove registers that aren't used from list

	BX LR

Pull_exit
	LDR r1, =FAIL
	;LDRH for unsigned halfward (16 bits)
	LDRH r0,[r1] ;Return FAIL value

	;Restore context
	POP {r4,r5,r6,r7,r8,r9,r10,r11} ;Remove registers that aren't used from list
	
	BX LR

	ENDP


;This subroutine returns the currently used size of the software FIFO
;Input arguments
;	r0: 0/1 = Tx/Rx
Size_FIFO	PROC
	;Push context
	PUSH {r4,r5,r6,r7,r8,r9,r10,r11} ;Remove registers that aren't used from list

	;Are you using TxFIFO or RxFIFO?
	CMP r0,#0
	BNE Size_RxFIFO

Size_TxFIFO
	;Load Tx counters
	LDR r0, =TxPutI
	LDR r2,[r0]
	LDR r0, =TxGetI
	LDR r3,[r0]

	B Size_cont

Size_RxFIFO
	;Load Rx counters
	LDR r0, =RxPutI
	LDR r2,[r0]
	LDR r0, =RxGetI
	LDR r3,[r0]

Size_cont
	SUB r0,r2,r3
	
	;Restore context
	POP {r4,r5,r6,r7,r8,r9,r10,r11} ;Remove registers that aren't used from list
	
	BX LR

	ENDP
		
	END