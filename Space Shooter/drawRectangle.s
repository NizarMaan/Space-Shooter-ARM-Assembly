.section .text

.globl DrawRectangle

//frameBuffer = r0, x-cord = r1, y-cord = r2, colour = r3 Xdimension = stack1 Ydimension = stack2
//Creates a square with dimensions given
DrawRectangle:	
    pop     {r5, r4}
    push    {r6-r10, lr}


    mov     r6, #0               // x-counter
    mov     r7, #0               // y-counter

    b       HLoop

VLoop:
    sub     r6, r4             // # of pixels
    sub     r1, r4             // # of pixels
HLoop:
    push    {r0-r3}
	bl		DrawPixel16bpp
    pop     {r0-r3}

    add     r1, #1
    add     r6, #1
    cmp     r6, r4             // # of pixels
    blt     HLoop

    add     r7, #1
    add     r2, #1

    cmp     r7, r5             // # of pixels
    blt     VLoop 


    pop     {r6-r10, lr}
    bx      lr
