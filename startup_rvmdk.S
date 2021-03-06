; <<< Use Configuration Wizard in Context Menu >>>
;******************************************************************************
;
; startup_rvmdk.S - Startup code for use with Keil's uVision.
;
; Copyright (c) 2012-2017 Texas Instruments Incorporated.  All rights reserved.
; Software License Agreement
; 
; Texas Instruments (TI) is supplying this software for use solely and
; exclusively on TI's microcontroller products. The software is owned by
; TI and/or its suppliers, and is protected under applicable copyright
; laws. You may not combine this software with "viral" open-source
; software in order to form a larger program.
; 
; THIS SOFTWARE IS PROVIDED "AS IS" AND WITH ALL FAULTS.
; NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT
; NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
; A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. TI SHALL NOT, UNDER ANY
; CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
; DAMAGES, FOR ANY REASON WHATSOEVER.
; 
; This is part of revision 2.1.4.178 of the EK-TM4C123GXL Firmware Package.
;
;******************************************************************************

;******************************************************************************
;
; <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
;
;******************************************************************************
Stack   EQU     0x00000200

;******************************************************************************
;
; <o> Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
;
;******************************************************************************
Heap    EQU     0x00000000

;******************************************************************************
;
; Allocate space for the stack.
;
;******************************************************************************

		;includes constants I define to startup file
		INCLUDE my_Constants.s
		;includes functions I define
		;INCLUDE my_Subroutines.s
		;Include variables I define to startup file
		IMPORT PB5_MASK
		;IMPORT TxPutI
		;IMPORT TxGetI
		;IMPORT TxFifo
		;IMPORT RxPutI
		;IMPORT RxGetI
		;IMPORT RxFifo

        AREA    STACK, NOINIT, READWRITE, ALIGN=3
StackMem
        SPACE   Stack
__initial_sp

;******************************************************************************
;
; Allocate space for the heap.
;
;******************************************************************************
        AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
HeapMem
        SPACE   Heap
__heap_limit

;******************************************************************************
;
; Indicate that the code in this file preserves 8-byte alignment of the stack.
;
;******************************************************************************
        PRESERVE8

;******************************************************************************
;
; Place code into the reset code section.
;
;******************************************************************************
        AREA    RESET, CODE, READONLY
        THUMB

;******************************************************************************
;
; The vector table.
;
;******************************************************************************
        EXPORT  __Vectors
__Vectors
        DCD     StackMem + Stack            ; Top of Stack
        DCD     Reset_Handler               ; Reset Handler
        DCD     NmiSR                       ; NMI Handler
        DCD     FaultISR                    ; Hard Fault Handler
        DCD     IntDefaultHandler           ; The MPU fault handler
        DCD     IntDefaultHandler           ; The bus fault handler
        DCD     IntDefaultHandler           ; The usage fault handler
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     IntDefaultHandler           ; SVCall handler
        DCD     IntDefaultHandler           ; Debug monitor handler
        DCD     0                           ; Reserved
        DCD     IntDefaultHandler           ; The PendSV handler
        DCD     SysTick_Handler           	; The SysTick handler
        DCD     IntDefaultHandler           ; GPIO Port A
        DCD     IntDefaultHandler           ; GPIO Port B
        DCD     IntDefaultHandler           ; GPIO Port C
        DCD     IntDefaultHandler           ; GPIO Port D
        DCD     IntDefaultHandler           ; GPIO Port E
        DCD     UART0_Handler	            ; UART0 Rx and Tx
        DCD     UART1_Handler 	            ; UART1 Rx and Tx
        DCD     IntDefaultHandler           ; SSI0 Rx and Tx
        DCD     IntDefaultHandler           ; I2C0 Master and Slave
        DCD     IntDefaultHandler           ; PWM Fault
        DCD     IntDefaultHandler           ; PWM Generator 0
        DCD     IntDefaultHandler           ; PWM Generator 1
        DCD     IntDefaultHandler           ; PWM Generator 2
        DCD     IntDefaultHandler           ; Quadrature Encoder 0
        DCD     IntDefaultHandler           ; ADC Sequence 0
        DCD     IntDefaultHandler           ; ADC Sequence 1
        DCD     IntDefaultHandler           ; ADC Sequence 2
        DCD     IntDefaultHandler           ; ADC Sequence 3
        DCD     IntDefaultHandler           ; Watchdog timer
        DCD     Timer0A_Handler	            ; Timer 0 subtimer A
        DCD     IntDefaultHandler           ; Timer 0 subtimer B
        DCD     IntDefaultHandler           ; Timer 1 subtimer A
        DCD     IntDefaultHandler           ; Timer 1 subtimer B
        DCD     IntDefaultHandler           ; Timer 2 subtimer A
        DCD     IntDefaultHandler           ; Timer 2 subtimer B
        DCD     IntDefaultHandler           ; Analog Comparator 0
        DCD     IntDefaultHandler           ; Analog Comparator 1
        DCD     IntDefaultHandler           ; Analog Comparator 2
        DCD     IntDefaultHandler           ; System Control (PLL, OSC, BO)
        DCD     IntDefaultHandler           ; FLASH Control
        DCD     IntDefaultHandler           ; GPIO Port F
        DCD     IntDefaultHandler           ; GPIO Port G
        DCD     IntDefaultHandler           ; GPIO Port H
        DCD     IntDefaultHandler           ; UART2 Rx and Tx
        DCD     IntDefaultHandler           ; SSI1 Rx and Tx
        DCD     IntDefaultHandler           ; Timer 3 subtimer A
        DCD     IntDefaultHandler           ; Timer 3 subtimer B
        DCD     IntDefaultHandler           ; I2C1 Master and Slave
        DCD     IntDefaultHandler           ; Quadrature Encoder 1
        DCD     IntDefaultHandler           ; CAN0
        DCD     IntDefaultHandler           ; CAN1
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     IntDefaultHandler           ; Hibernate
        DCD     IntDefaultHandler           ; USB0
        DCD     IntDefaultHandler           ; PWM Generator 3
        DCD     IntDefaultHandler           ; uDMA Software Transfer
        DCD     IntDefaultHandler           ; uDMA Error
        DCD     IntDefaultHandler           ; ADC1 Sequence 0
        DCD     IntDefaultHandler           ; ADC1 Sequence 1
        DCD     IntDefaultHandler           ; ADC1 Sequence 2
        DCD     IntDefaultHandler           ; ADC1 Sequence 3
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     IntDefaultHandler           ; GPIO Port J
        DCD     IntDefaultHandler           ; GPIO Port K
        DCD     IntDefaultHandler           ; GPIO Port L
        DCD     IntDefaultHandler           ; SSI2 Rx and Tx
        DCD     IntDefaultHandler           ; SSI3 Rx and Tx
        DCD     IntDefaultHandler           ; UART3 Rx and Tx
        DCD     IntDefaultHandler           ; UART4 Rx and Tx
        DCD     IntDefaultHandler           ; UART5 Rx and Tx
        DCD     IntDefaultHandler           ; UART6 Rx and Tx
        DCD     IntDefaultHandler           ; UART7 Rx and Tx
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     IntDefaultHandler           ; I2C2 Master and Slave
        DCD     IntDefaultHandler           ; I2C3 Master and Slave
        DCD     Timer4A_Handler	            ; Timer 4 subtimer A
        DCD     Timer4B_Handler             ; Timer 4 subtimer B
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     IntDefaultHandler           ; Timer 5 subtimer A
        DCD     IntDefaultHandler           ; Timer 5 subtimer B
        DCD     IntDefaultHandler           ; Wide Timer 0 subtimer A
        DCD     IntDefaultHandler           ; Wide Timer 0 subtimer B
        DCD     IntDefaultHandler           ; Wide Timer 1 subtimer A
        DCD     IntDefaultHandler           ; Wide Timer 1 subtimer B
        DCD     IntDefaultHandler           ; Wide Timer 2 subtimer A
        DCD     IntDefaultHandler           ; Wide Timer 2 subtimer B
        DCD     IntDefaultHandler           ; Wide Timer 3 subtimer A
        DCD     IntDefaultHandler           ; Wide Timer 3 subtimer B
        DCD     IntDefaultHandler           ; Wide Timer 4 subtimer A
        DCD     IntDefaultHandler           ; Wide Timer 4 subtimer B
        DCD     IntDefaultHandler           ; Wide Timer 5 subtimer A
        DCD     IntDefaultHandler           ; Wide Timer 5 subtimer B
        DCD     IntDefaultHandler           ; FPU
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     IntDefaultHandler           ; I2C4 Master and Slave
        DCD     IntDefaultHandler           ; I2C5 Master and Slave
        DCD     IntDefaultHandler           ; GPIO Port M
        DCD     IntDefaultHandler           ; GPIO Port N
        DCD     IntDefaultHandler           ; Quadrature Encoder 2
        DCD     0                           ; Reserved
        DCD     0                           ; Reserved
        DCD     IntDefaultHandler           ; GPIO Port P (Summary or P0)
        DCD     IntDefaultHandler           ; GPIO Port P1
        DCD     IntDefaultHandler           ; GPIO Port P2
        DCD     IntDefaultHandler           ; GPIO Port P3
        DCD     IntDefaultHandler           ; GPIO Port P4
        DCD     IntDefaultHandler           ; GPIO Port P5
        DCD     IntDefaultHandler           ; GPIO Port P6
        DCD     IntDefaultHandler           ; GPIO Port P7
        DCD     IntDefaultHandler           ; GPIO Port Q (Summary or Q0)
        DCD     IntDefaultHandler           ; GPIO Port Q1
        DCD     IntDefaultHandler           ; GPIO Port Q2
        DCD     IntDefaultHandler           ; GPIO Port Q3
        DCD     IntDefaultHandler           ; GPIO Port Q4
        DCD     IntDefaultHandler           ; GPIO Port Q5
        DCD     IntDefaultHandler           ; GPIO Port Q6
        DCD     IntDefaultHandler           ; GPIO Port Q7
        DCD     IntDefaultHandler           ; GPIO Port R
        DCD     IntDefaultHandler           ; GPIO Port S
        DCD     IntDefaultHandler           ; PWM 1 Generator 0
        DCD     IntDefaultHandler           ; PWM 1 Generator 1
        DCD     IntDefaultHandler           ; PWM 1 Generator 2
        DCD     IntDefaultHandler           ; PWM 1 Generator 3
        DCD     IntDefaultHandler           ; PWM 1 Fault

;******************************************************************************
;
; This is the code that gets called when the processor first starts execution
; following a reset event.
;
;******************************************************************************
        EXPORT  Reset_Handler
Reset_Handler
        ;
        ; Enable the floating-point unit.  This must be done here to handle the
        ; case where main() uses floating-point and the function prologue saves
        ; floating-point registers (which will fault if floating-point is not
        ; enabled).  Any configuration of the floating-point unit using
        ; DriverLib APIs must be done here prior to the floating-point unit
        ; being enabled.
        ;
        ; Note that this does not use DriverLib since it might not be included
        ; in this project.
        ;
        MOVW    R0, #0xED88
        MOVT    R0, #0xE000
        LDR     R1, [R0]
        ORR     R1, #0x00F00000
        STR     R1, [R0]

        ;
        ; Call the C library enty point that handles startup.  This will copy
        ; the .data section initializers from flash to SRAM and zero fill the
        ; .bss section.
        ;
		
		
		;Setting up RAM myself here
		LDR r2, =PB5_MASK	;get RAM address of PB5 mask (pointer)
		LDR r3,[r2]	;get the value of PB5 mask
		
		;I'm getting trash data this RAM address. Clearing and properly setting to ONLY 0xF0
		BFC r3,#0,#32
		
		ORR r3, r3, #0x20;#0xF0
		STR r3,[r2]
	
        IMPORT  __main
        B       __main

;******************************************************************************
;
; This is the code that gets called when the processor receives a NMI.  This
; simply enters an infinite loop, preserving the system state for examination
; by a debugger.
;
;******************************************************************************
NmiSR
        B       NmiSR

;******************************************************************************
;
; This is the code that gets called when the processor receives a fault
; interrupt.  This simply enters an infinite loop, preserving the system state
; for examination by a debugger.
;
;******************************************************************************
FaultISR
        B       FaultISR

;******************************************************************************
;
; This is the code that gets called when the processor receives an unexpected
; interrupt.  This simply enters an infinite loop, preserving the system state
; for examination by a debugger.
;
;******************************************************************************


;I added the SysTick_Handler here. This toggle GPIODATA so the LED blinks
SysTick_Handler	PROC
	
	EXPORT SysTick_Handler
		
	;write "high" to data register for port F pin 1 to turn on red LED. GPIODATA
	LDR r0, =AHB_PORTB
	LDR r1, =PB5_MASK ;Get RAM address of PB5 mask value
	LDR r2,[r1] ;Grab value of PB5 mask
	EOR r2, r2, #GPIOP5;#0x20;#0xF0	;Toggle mas to toggle PB5
	STR r2,[r1]	;Store the toggled mask to properly toggle next time
	STR r2,[r0,#GPIODATAPB5]
	;LDR r2,[r0,#GPIODATAPB5]

	;return to __main
	BX LR
	
	ENDP



IntDefaultHandler
        B       IntDefaultHandler


;I added the Timer0A_Handler here. 
Timer0A_Handler	PROC
	
	EXPORT Timer0A_Handler
		
	;write "high" to data register for port F pin 1 to turn on red LED. GPIODATA
	LDR r0, =AHB_PORTB
	LDR r1, =PB5_MASK ;Get RAM address of PB5 mask value
	LDR r2,[r1] ;Grab value of PB5 mask
	EOR r2, r2, #GPIOP5;#0x20;#0xF0	;Toggle mas to toggle PB5
	STR r2,[r1]	;Store the toggled mask to properly toggle next time
	STR r2,[r0,#GPIODATAPB5]
	;LDR r2,[r0,#GPIODATAPB5]


	;Clear RIS bit
	LDR r0, =TIMER16_0
	LDR r1,[r0, #GPTMICR]
	
	BFC r1,#0,#1
	ORR r1,r1,#1
	
	STR r1,[r0, #GPTMICR]

	;return to __main
	BX LR
	
	ENDP
		
Timer4A_Handler	PROC
	EXPORT Timer4A_Handler
		
	;write "high" to data register for port F pin 1 to turn on red LED. GPIODATA
	LDR r0, =AHB_PORTB
	LDR r1, =PB5_MASK ;Get RAM address of PB5 mask value
	LDR r2,[r1] ;Grab value of PB5 mask
	EOR r2, r2, #GPIOP5;#0x20;#0xF0	;Toggle mas to toggle PB5
	STR r2,[r1]	;Store the toggled mask to properly toggle next time
	STR r2,[r0,#GPIODATAPB5]
	;LDR r2,[r0,#GPIODATAPB5]


	;Clear RIS bit
	LDR r0, =SYS_CONTROL
	LDR r1,[r0, #GPTMICR]
	
	BFC r1,#0,#1
	ORR r1,r1,#1
	
	STR r1,[r0, #GPTMICR]

	;return to __main
	BX LR
	
	ENDP
		
Timer4B_Handler	PROC
	EXPORT Timer4B_Handler
		
	;write "high" to data register for port F pin 1 to turn on red LED. GPIODATA
	LDR r0, =AHB_PORTB
	LDR r1, =PB5_MASK ;Get RAM address of PB5 mask value
	LDR r2,[r1] ;Grab value of PB5 mask
	EOR r2, r2, #GPIOP5;#0x20;#0xF0	;Toggle mas to toggle PB5
	STR r2,[r1]	;Store the toggled mask to properly toggle next time
	STR r2,[r0,#GPIODATAPB5]
	;LDR r2,[r0,#GPIODATAPB5]


	;Clear RIS bit
	LDR r0, =SYS_CONTROL
	LDR r1,[r0, #GPTMICR]
	
	BFC r1,#0,#1
	ORR r1,r1,#1
	
	STR r1,[r0, #GPTMICR]

	;return to __main
	BX LR
	
	ENDP
		
;I added the UART0 handler here
UART0_Handler	PROC
	EXPORT UART0_Handler
	;Save context
	PUSH {r4,r5,r6} ;Add more registers if you'll be using more
	
	;Load UARTMIS to check for conditions
	LDR r0, =UART0
	LDR r1,[r0, #UARTMIS]
	
	;Rx Time out condition
	AND r2,r1,#(1<<6)
	LSR r2,r2,#6
	
	;TxFIFO condition
	AND r3,r1,#(1<<5)
	LSR r3,r3,#5
	
	;RxFIFO condition
	AND r4,r1,#(1<<4)
	LSR r4,r4,#4
	
	;Rx Time out interrupt
	CMP r2,#1
	BEQ RTISR0
	
	;TxFIFO interrupt
	CMP r3,#1
	BEQ TxFIFOISR0
	
	;RxFIFO interrupt
	CMP r4,#1
	BEQ RxFIFOISR0
	
	;Services the interrupt caused by a time out
RTISR0		
	;Write a '??' character to send at time out
	LDR r0, =UART0
	
	;The '?' character
	MOV r1,#0x3F
	MOV r2,#0x3F
	
	;Write '??' to UARTDR
	STR r1,[r0, #UARTDR]
	STR r2,[r0, #UARTDR]

	;Clear RIS bit
	LDR r0, =UART0
	LDR r1,[r0, #UARTICR]
	BFC r1,#6,#1
	ORR r1,r1,#(1<<6)
	STR r1,[r0, #UARTICR]
		
	;Restore context
	POP {r4,r5,r6} ;Add more registers if you'll be using more
		
	BX LR
		
	;Services the interrupt caused by a TxFIFO
TxFIFOISR0		
	;Write actions here

	;Clear RIS bit
	LDR r0, =UART0
	LDR r1,[r0, #UARTICR]
	BFC r1,#5,#1
	ORR r1,r1,#(1<<5)
	STR r1,[r0, #UARTICR]
		
	;Restore context
	POP {r4,r5,r6} ;Add more registers if you'll be using more
		
	BX LR
		
	;Services the interrupt caused by RxFIFO
RxFIFOISR0		
	;Read from RxFIFO via UARTDR
	LDR r0, =UART0
	LDR r1,[r0, #UARTDR] ;First byte
	LDR r2,[r0, #UARTDR] ;Second byte
	
	;In case bits need to be reversed
	RBIT r2, r3
	
	;If r2 = 'o' (lower case)
	CMP r2,#0x6F
	BNE RxFIFOISR0_cont
	
	;write "high" to data register for port F pin 1 to turn on red LED. GPIODATA
	LDR r0, =AHB_PORTB
	LDR r1, =PB5_MASK ;Get RAM address of PB5 mask value
	LDR r2,[r1] ;Grab value of PB5 mask
	EOR r2, r2, #GPIOP5;#0x20;#0xF0	;Toggle mas to toggle PB5
	STR r2,[r1]	;Store the toggled mask to properly toggle next time
	STR r2,[r0,#GPIODATAPB5]

RxFIFOISR0_cont
	;Clear RIS bit
	LDR r0, =UART0
	LDR r1,[r0, #UARTICR]
	BFC r1,#4,#1
	ORR r1,r1,#(1<<4)
	STR r1,[r0, #UARTICR]
		
	;Restore context
	POP {r4,r5,r6} ;Add more registers if you'll be using more
		
	BX LR
	
	ENDP
	
;I added the UART1 handler here
UART1_Handler	PROC
	EXPORT UART1_Handler
	;Save context
	PUSH {r4,r5,r6} ;Add more registers if you'll be using more
	
	;Load UARTMIS to check for conditions
	LDR r0, =UART1
	LDR r1,[r0, #UARTMIS]
	
	;Rx Time out condition
	AND r2,r1,#(1<<6)
	LSR r2,r2,#6
	
	;TxFIFO condition
	AND r3,r1,#(1<<5)
	LSR r3,r3,#5
	
	;RxFIFO condition
	AND r4,r1,#(1<<4)
	LSR r4,r4,#4
	
	;TxFIFO interrupt
	CMP r3,#1
	BEQ TxFIFOISR1
	
	;RxFIFO interrupt
	CMP r4,#1
	BEQ RxFIFOISR1
	
	;Rx Time out interrupt
	CMP r2,#1
	BEQ RTISR1
	
	;Services the interrupt caused by a time out
RTISR1	
	;Write actions here

	;Clear RIS bit
	LDR r0, =UART1
	LDR r1,[r0, #UARTICR]
	BFC r1,#6,#1
	ORR r1,r1,#(1<<6)
	STR r1,[r0, #UARTICR]
		
	;Restore context
	POP {r4,r5,r6} ;Add more registers if you'll be using more
		
	BX LR
		
	;Services the interrupt caused by a TxFIFO
TxFIFOISR1	
	;Write actions here

	;Clear RIS bit
	LDR r0, =UART1
	LDR r1,[r0, #UARTICR]
	BFC r1,#5,#1
	ORR r1,r1,#(1<<5)
	STR r1,[r0, #UARTICR]
		
	;Restore context
	POP {r4,r5,r6} ;Add more registers if you'll be using more
		
	BX LR
		
	;Services the interrupt caused by RxFIFO
RxFIFOISR1
	;Read from RxFIFO via UARTDR
	LDR r0, =UART1
	LDR r1,[r0, #UARTDR] ;First byte (plus 4 bits of flags)
	;LDR r2,[r0, #UARTDR] ;Second byte (plus 4 bits of flags)
	
	;This is not necessary. Bits come in in the correct position
	;In case bits need to be reversed
	;RBIT r3,r1
	;RBIT r4,r2
	
	;Clear 4 bit flags
	BFC r1,#8,#4; if using RBIT, change r1 ro r3
	;BFC r4,#8,#4
	
	;If r1 = 'o' (lower case)
	CMP r1,#0x6F
	
	;Toggle bit mask for PB5 to flash external LED.
	LDR r0, =AHB_PORTB
	LDR r1, =PB5_MASK ;Get RAM address of PB5 mask value
	LDR r2,[r1] ;Grab value of PB5 mask
	EOR r2, r2, #GPIOP5;#0x20;#0xF0	;Toggle mas to toggle PB5
	STR r2,[r1]	;Store the toggled mask to properly toggle next time
	STR r2,[r0,#GPIODATAPB5]

RxFIFOISR_cont1
	;Clear RIS bit
	LDR r0, =UART1
	LDR r1,[r0, #UARTICR]
	BFC r1,#4,#1
	ORR r1,r1,#(1<<4)
	STR r1,[r0, #UARTICR]
		
	;Restore context
	POP {r4,r5,r6} ;Add more registers if you'll be using more
		
	BX LR
	
	ENDP
	
	
	
	
	
;******************************************************************************
;
; Make sure the end of this section is aligned.
;
;******************************************************************************
        ALIGN

;******************************************************************************
;
; Some code in the normal code section for initializing the heap and stack.
;
;******************************************************************************
        AREA    |.text|, CODE, READONLY

;******************************************************************************
;
; The function expected of the C library startup code for defining the stack
; and heap memory locations.  For the C library version of the startup code,
; provide this function so that the C library initialization code can find out
; the location of the stack and heap.
;
;******************************************************************************
    IF :DEF: __MICROLIB
        EXPORT  __initial_sp
        EXPORT  __heap_base
        EXPORT  __heap_limit
    ELSE
        IMPORT  __use_two_region_memory
        EXPORT  __user_initial_stackheap
__user_initial_stackheap
        LDR     R0, =HeapMem
        LDR     R1, =(StackMem + Stack)
        LDR     R2, =(HeapMem + Heap)
        LDR     R3, =StackMem
        BX      LR
    ENDIF

;******************************************************************************
;
; Make sure the end of this section is aligned.
;
;******************************************************************************
        ALIGN

;******************************************************************************
;
; Tell the assembler that we're done.
;
;******************************************************************************
        END
