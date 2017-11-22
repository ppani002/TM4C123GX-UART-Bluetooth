	;This code is for the Rx and Tx software FIFO's. The FIFO size is fixed to 16 bytes of data. To make it larger, change SIZE field. It must be 2^n.

	;LDRB for 8 unsigned bits to 32-bit register
	;LDRSB for 8 signed bits to 32-bit register
	;STRH for 8 usigned bits to 32-bit register
	;STRB for 8 signed bits to 32-bit register



	AREA my_Variables,DATA,READWRITE

	ALIGN 1
	;Temporary location to write to UARTDR
temp	DCB 0;Used to write to UARTDR

	;Software FIFOs. Static
TxFifo	DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;16 bytes
RxFifo	DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;16 bytes

	ALIGN 4
	;Tx counters
TxPutI	DCD 0
TxGetI	DCD 0

	;Rx counters
RxPutI	DCD 0
RxGetI	DCD 0




	AREA my_Constants,DATA,READONLY

	ALGIN 2
SIZE	DCW 16
SUCCESS	DCW 1
FAIL	DCW 0





	AREA |.text|,CODE,READONLY

;This subroutine is used to push data onto software FIFO
;Input parameters
;	r0: 0/1 = Tx/Rx
;	r1: 8-bit data value
Push_FIFO	PROC
	;Push context
	PUSH {r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,LR,PC} ;Remove registers that aren't used from list

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
	AND r3,r3,r56 ;(PutI - GetI) & ~(SIZE - 1)

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
	POP {r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,LR,PC} ;Remove registers that aren't used from list

	BX LR

Push_exit
	LDR r1, =FAIL
	;LDRH for unsigned halfward (16 bits)
	LDRH r0,[r1] ;Return FAIL value

	;Restore context
	POP {r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,LR,PC} ;Remove registers that aren't used from list
	
	BX LR

	ENDP

;This subroutine is used to pull data from software FIFO
;Input arguments
;	r0: 0/1 = Tx/Rx
;	r1: Address of temporary variable (? It can be a register too. To write to a variable)
Pull_FIFO	PROC
	;Push context
	PUSH {r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,LR,PC} ;Remove registers that aren't used from list

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
	POP {r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,LR,PC} ;Remove registers that aren't used from list

	BX LR

Pull_exit
	LDR r1, =FAIL
	;LDRH for unsigned halfward (16 bits)
	LDRH r0,[r1] ;Return FAIL value

	;Restore context
	POP {r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,LR,PC} ;Remove registers that aren't used from list
	
	BX LR

	ENDP


;This subroutine returns the currently used size of the software FIFO
;Input arguments
;	r0: 0/1 = Tx/Rx
Size_FIFO	PROC
	;Push context
	PUSH {r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,LR,PC} ;Remove registers that aren't used from list

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
	POP {r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,LR,PC} ;Remove registers that aren't used from list
	
	BX LR

	ENDP

