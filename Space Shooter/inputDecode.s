.section .text

.globl InputDecode

/* 
Takes as input in r0 the bits that represent which buttons have been pressed. As output, it gives the button pressed. 
*/

/* 
output in r0:

    start       0
    up          1
    down        2
    left        3
    right       4
    A           5
    No button   6
*/

InputDecode:
    push    {r4-r10, lr}

    mvn     r1, r0



    output  .req    r3
    bitmask .req    r4

    mov     output, #0      // Initialize output
    mov     bitmask, #0b1000   // Initialize bitmask


// determines which button was pressed 
determineInput:
    and     r5, r1, bitmask
    cmp     r5, bitmask

    moveq   r0, output
    beq     end
    
    lsl     bitmask, #1
    add     output, #1

    cmp     output, #6

    bne     determineInput

    mov     r0, output


end:
    pop     {r4-r10, lr}
    bx      lr

