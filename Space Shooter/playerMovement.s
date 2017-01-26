.section .text

.globl PlayerMovement

/*moves the player 
r0 = FrameBuffer, r1 = Direction

Direction:
    0 = up
    1 = down
    2 = left
    3 = right
*/

PlayerMovement:
    push    {r4-r10, lr}

    Movement       .req    r9

    mov     Movement, r1

    cmp     Movement, #0
    bleq     moveUp
    
    cmp     Movement, #1
    bleq     moveDown

    cmp     Movement, #2
    bleq     moveLeft

    bl      moveRight

end:
    pop     {r4-r10, lr}
    bx      lr




moveUp:
    ldr     r8, =PlayerPos
    ldr     r5, [r8, #4]        // y-cord
	ldr		r7, =620
    cmp     r5, r7

    ble     end

    bl      ClearPlayer    
    sub     r5, #40             // move 40 pixels up
    str     r5, [r8, #4]
    bl      DrawPlayer

    b       end


moveDown:
    ldr     r8, =PlayerPos
    ldr     r5, [r8, #4]        // y-cord
    ldr     r7, =694
    cmp     r5, r7

    bge     end

    bl      ClearPlayer
    add     r5, #40             // move 40 pixels down
    str     r5, [r8, #4]
    bl      DrawPlayer

    b       end


moveRight:
    ldr     r8, =PlayerPos
    ldr     r5, [r8]            // y-cord
    ldr     r7, =925
    cmp     r5, r7

    bge     end

    bl      ClearPlayer
    add     r5, #40             // move 40 pixels right
    str     r5, [r8]
    bl      DrawPlayer

    b       end


moveLeft:
    ldr     r8, =PlayerPos
    ldr     r5, [r8]            // y-cord
    cmp     r5, #41

    ble     end

    bl      ClearPlayer
    sub     r5, #40             // move 40 pixels left
    str     r5, [r8]
    bl      DrawPlayer

    b       end
    







