.section .text

.globl GameFlow

// Where the game happens
//r0 = FrameBuffer
GameFlow:
    push    {r4-r12, lr}

    FrameBufferPointer      .req    r10
    mov     FrameBufferPointer, r0

    SNESInput       .req    r9

    bl      DrawStartMenu
    b       SNESLoop


// getting input from the controller
SNESLoop:
    bl      ReadingSNES
    bl      InputDecode
    mov     SNESInput, r0
    cmp     SNESInput, #6
    bne     waitUntilRelease

buttonReleased:
    mov     r0, SNESInput
    mov     r1, FrameBufferPointer
    
    bl      InputAction

    mov     r0, FrameBufferPointer
    bl      AIShoot                             // enemy boxes will shoot
    bl      MoveBullets                         // moving all the bullets
    bl      HitDetection                        // hit detection for the bullets
    bl      AIMovement                          // movement of the ai
    bl      wait                                // wait loop
    mov     r0, FrameBufferPointer
    bl      CheckEndGame                        // checking to see if game is over

    b       SNESLoop

   
    pop     {r4-r12, lr} 
    bx      lr


wait:
	ldr r0, =0x20003004         // address of CLO 
	ldr r1, [r0]                // read CLO 
    ldr r2, =10000   
	add r1, r2                  // add 400000 micros
waitLoop: 
	ldr r2, [r0] 
	cmp r1, r2                  // stop when CLO = r1 
	bhi waitLoop 
	bx lr

// waits until the button is released before doing the action
waitUntilRelease:
    bl      ReadingSNES
    bl      InputDecode
    mov     r5, r0

    mov     r0, FrameBufferPointer
    bl      AIShoot                             // enemy boxes will shoot
    bl      MoveBullets                         // moving all the bullets
    bl      HitDetection                        // hit detection for the bullets
    bl      AIMovement                          // movement of the ai
    bl      wait                                // wait loop
    mov     r0, FrameBufferPointer
    bl      CheckEndGame                        // checking to see if the game is over

    cmp     r5, #6
    bne     waitUntilRelease
    beq     buttonReleased
