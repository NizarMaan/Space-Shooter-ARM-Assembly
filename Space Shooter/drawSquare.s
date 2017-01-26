.section .text

.globl DrawSquare

//frameBuffer = r0, x-cord = r1, y-cord = r2, colour = r3, dimension = first on stack
//Creates a square with dimensions given
DrawSquare:	
    pop     {r4}
    push    {r5-r10, lr}


    mov     r5, #0               // x-counter
    mov     r6, #0               // y-counter

    b       HLoop

VLoop:
    sub     r5, r4             // # of pixels
    sub     r1, r4             // # of pixels
HLoop:
    push    {r0-r3}
	bl		DrawPixel16bpp
    pop     {r0-r3}

    add     r1, #1
    add     r5, #1
    cmp     r5, r4             // # of pixels
    blt     HLoop

    add     r6, #1
    add     r2, #1

    cmp     r6, r4             // # of pixels
    blt     VLoop 


    pop     {r5-r10, lr}
    bx      lr

