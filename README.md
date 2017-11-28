# TM4C123GX-UART-Bluetooth
This project contains files for a program that utilizes the UART module of the TM4C123GX. It's used to communicate with an HC-05 bluetooth module to receive commands to turn on an external LED.
It's currently written so that a value of 'o' (lower case O) will toggle the value to toggle the data bit for PB5. The code can be modified by rewriting tasks
required in the appropriate parts in the UART1_Handler. 
