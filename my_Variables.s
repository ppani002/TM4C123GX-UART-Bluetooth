	AREA My_Variables, DATA, READWRITE
	THUMB
	
;GPIO data mask	
		EXPORT PB5_MASK
PB5_MASK DCD 240;0x000000F0
	
;FIFO variables
	ALIGN 1
	;Temporary location to write to UARTDR
		EXPORT temp
temp	DCB 0;Used to write to UARTDR

	;Software FIFOs. Static
TxFifo	DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;16 bytes
RxFifo	DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;16 bytes

	ALIGN 4
		EXPORT TxPutI
		EXPORT TxGetI
	;Tx counters
TxPutI	DCD 0
TxGetI	DCD 0

		EXPORT RxPutI
		EXPORT RxGetI
	;Rx counters
RxPutI	DCD 0
RxGetI	DCD 0
	
	END