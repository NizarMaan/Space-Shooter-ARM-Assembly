.section .text

.equ	GPIOFSEL0,	0x20200000  
.equ	GPIOFSEL1,	0x20200004  

.globl initController

//	Initializes SNES controller

initController:
	
	// Set LATCH (GPIO pin 09 to output)
	ldr r0, =GPIOFSEL0 // base GPIO reg
	ldr r1, [r0] //copy GPFSEL0 into r1
	mov r2, #7 // 0b0111
	lsl r2, #27 //index of 1st bit for pin 09
	bic r1, r2 //clear pin 09 bits
	mov r3, #1 //output function code
	lsl r3, #27 //sets 1 on the 27th bit
	orr r1, r3 //set pin 09 function in r1
	str r1, [r0] //write back to GPFSEL0
	
	//Set DATA line (GPIO pin 10 to input)	
    ldr r0, =GPIOFSEL1 //base GPIO reg
	ldr r1, [r0] //copy GPFSEL1 into r1
	mov r2, #7 //0b0111
	bic r1, r2 //clear pin 10 bits (sets input)
	str r1, [r0] //write back to GPFSEL1
	
	//Start CLOCK line (GPIO pin 11 to output)
	ldr r0, =GPIOFSEL1 // base GPIO reg
	ldr r1, [r0] //copy GPFSEL1 into r1
	mov r2, #7 /0b0111
	lsl r2, #3 //index of 1st bit for pin 11
	bic r1, r2 //clear pin 11 bits
	mov r3, #1 //output function code
	lsl r3, #3 //sets 1 on the 3rd bit
	orr r1, r3 //set pin11 function in r1
	str r1, [r0] //write back to GPFSEL1
	
	bx lr
	
