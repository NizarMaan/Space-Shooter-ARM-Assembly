/* Function to read SNES controller output
	Data is outputted into a bit string passed out of this function 
	through r0		*/

.section .text

.equ	GPIOFSEL0,	0x20200000
.equ	GPIOFSEL1,	0x20200004

.globl ReadingSNES
ReadingSNES:
	push {r4, r5, lr}
	mov r4, #0	//Register sampling buttons
	mov r1, #1	//write 1
	bl writeGPIOclk
	mov r1, #1	//write 1
	bl writeGPIOlat
	bl wait_12ms //wait 12 microseconds
	mov r1, #0 //write 0
	bl writeGPIOlat
	mov r5, #0 //i = 0
	
	//Loop to sample all buttons
pulseLoop:
	bl wait_6ms //wait 6 microseconds
	mov r1, #0 //write 0
	bl writeGPIOclk
	bl wait_6ms //wait 6 microseconds
	bl readGPIOdat
	cmp r0, #1
	bne Pushed
	lsl r0, r5	//If the button was pushed, shift to appropriate bit
	orr r4, r0	//Orr that specific bit
Pushed:
	mov r0, #3
	mov r1, #1
	bl writeGPIOclk
	add r5, #1
	cmp r5, #16
	blt pulseLoop
	mov r0, r4
	pop {r4, r5, pc}
	bx lr

writeGPIOlat:
	/* writeGPIO for LATCH */
	ldr r2, =GPIOFSEL0 //Base GPIO reg
	mov r3, #1 //0b001
	lsl r3, #9 //align for appropriate pin
	teq r1, #0
	streq r3, [r2, #40] //GPCLR0
	strne r3, [r2, #28] //GPSET0
	bx lr	

writeGPIOclk:
	/* writeGPIO for CLOCK */
	ldr r2, =GPIOFSEL0 //Base GPIO reg
	mov r3, #1 //0b001
	lsl r3, #11 //align for appropriate pin
	teq r1, #0
	streq r3, [r2, #40] //GPCLR0
	strne r3, [r2, #28] //GPSET0
	bx lr

readGPIOdat:
	ldr r2, =GPIOFSEL0 //base GPIO reg
	ldr r1, [r2, #52] //GPLEV1
	mov r3, #1
	lsl r3, #10
	and r1, r3 //mask everything else
	teq r1, #0
	moveq r0, #0 //return 0
	movne r0, #1 //return 1
	bx lr
	
wait_12ms:
	ldr r0, =0x20003004 // address of CLO 
	ldr r1, [r0] // read CLO 
	add r1, #12 // add 12 micros 
waitLoop: 
	ldr r2, [r0] 
	cmp r1, r2 // stop when CLO = r1 
	bhi waitLoop 
	bx lr
	
wait_6ms:
	ldr r0, =0x20003004 // address of CLO 
	ldr r1, [r0] // read CLO 
	add r1, #6 // add 6 micros
waitLoop2: 
	ldr r2, [r0] 
	cmp r1, r2 // stop when CLO = r1 
	bhi waitLoop2 
	bx lr
	
