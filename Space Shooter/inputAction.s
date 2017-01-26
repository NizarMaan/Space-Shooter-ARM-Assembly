.section .text

.globl InputAction

//r0 = an integer representing the action taken, r1 = FrameBuffer
InputAction:
    push    {r4-r10, lr}

    FrameBufferPointer      .req        r10
    mov     FrameBufferPointer, r1

    gameStateAddress    .req    r8
    gameState           .req    r9

    ldr gameStateAddress, =GameState
    ldrb gameState,  [gameStateAddress]                    
    
    // Pause button Pressed
    cmp     r0, #0
    beq     pause

    // Up button pressed
    cmp     r0, #1
    beq     moveUp

    // Down button pressed
    cmp     r0, #2
    beq     moveDown

    // Left button pressed
    cmp     r0, #3
    beq     moveLeft

    // Right button pressed
    cmp     r0, #4
    beq     moveRight

    // A button Pressed
    cmp     r0, #5
    beq     action  

    b       end                 // no input 
    
pause:
    ldr     r2, =GameState
    ldrb    r3, [r2]
    cmp     r3, #0
    beq     end

    cmp     r3, #2
    beq     startGame

    cmp      r3, #3
    moveq    r0, FrameBufferPointer    
    bleq     ClearScreen
    bleq     Reset
    bleq     DrawScreen
    ldreq    r2, =GameState
    moveq    r3, #1
    streqb  r3, [r2]
    beq     end

    mov     r3, #0
    strb    r3, [r2]

    mov     r0, FrameBufferPointer
    bl      DrawPauseMenu
   
    b       end

moveUp:
    ldr     r2, =GameState
    ldrb    r3, [r2]
    
    cmp     r3, #3
    moveq   r0, FrameBufferPointer    
    bleq    ClearScreen
    bleq    Reset
    bleq    DrawScreen

    cmp     r3, #2
    beq     end
    
    cmp     r3, #0               //if the game is currently paused
    beq     gamePaused

    mov     r0, FrameBufferPointer
    mov     r1, #0
    bl      PlayerMovement

    b       end

moveDown:
    ldr     r2, =GameState
    ldrb    r3, [r2]

    cmp     r3, #3
    moveq   r0, FrameBufferPointer    
    bleq    ClearScreen
    bleq    Reset
    bleq    DrawScreen 

    cmp     r3, #2
    beq     end  

    cmp     r3, #0               //if the game is currently paused
    beq     gamePaused
    
    mov     r0, FrameBufferPointer
    mov     r1, #1
    bl      PlayerMovement

    b       end

moveLeft:
    ldr     r2, =GameState
    ldrb    r3, [r2]

    cmp     r3, #3
    moveq   r0, FrameBufferPointer    
    bleq    ClearScreen
    bleq    Reset
    bleq    DrawScreen

    cmp     r3, #2
    beq     end

    cmp     r3, #0              // if the game is paused do nothing
    beq     end

    mov     r0, FrameBufferPointer
    mov     r1, #2
    bl      PlayerMovement

    b       end

moveRight:
    ldr     r2, =GameState
    ldrb    r3, [r2]

    cmp     r3, #3
    moveq   r0, FrameBufferPointer  
    bleq    ClearScreen
    bleq    Reset
    bleq    DrawScreen

    cmp     r3, #2
    beq     end
 
    cmp     r3, #0              // if the game is paused do nothing
    beq     end

    mov     r0, FrameBufferPointer
    mov     r1, #3
    bl       PlayerMovement

    b       end

action:
    ldr     r2, =GameState
    ldrb    r3, [r2]

    cmp      r3, #3
    moveq    r0, FrameBufferPointer
    bleq     ClearScreen
    bleq     Reset
    bleq     DrawScreen
    beq     end

    cmp     r3, #2
    beq     end

    cmp     r3, #0                  // if the game is paused, A will not shoot but do the action highlighted
    beq     pauseMenuAction

    mov     r0, FrameBufferPointer
    ldr     r2, =Bullet
    ldr     r3, [r2]
    cmp     r3, #1                  // if there is a bullet out won't shoot another one
    blne    PlayerShoot

    b       end

gamePaused:
    ldr     r2, =PauseMenuPointer
    ldrb    r3, [r2]

    cmp     r0, #1          // Checking to see if up or down was pressed
    subeq   r3, #1          // If up was pressed
    addne   r3, #1          // If down was pressed

    cmp     r3, #3          // Circular motion back to the top
    moveq   r3, #0

    cmp     r3, #-1         // Circular motion back to the bottom
    moveq   r3, #2

    strb    r3, [r2]

    mov     r0, FrameBufferPointer
    bl      DrawPauseMenu

    b       end

pauseMenuAction:
    ldr     r2, =PauseMenuPointer
    ldrb    r1, [r2]

    cmp     r1, #0                      // resume 
    ldreq   r2, =GameState
    moveq   r3, #1     
    streqb  r3, [r2]

    mov     r0, FrameBufferPointer
    bleq    ClearPauseMenu

    beq     end

    cmp     r1, #1
    bleq    ClearScreen
    bleq    Reset
    bleq    DrawScreen                      // restart 
    beq     end

    cmp     r1, #2
    bleq    ClearScreen
    bleq    Reset
    mov     gameState,  #2
    streqb  gameState,  [gameStateAddress]
    bleq    DrawStartMenu                            // quit 
    beq     end    

startGame:
    ldr     r3, =GameState
    mov     r2, #1
    strb    r2, [r3]

    mov     r0, FrameBufferPointer
    bl      ClearScreen
    bl      DrawScreen
    

end:
    pop     {r4-r10, lr}
    bx      lr
    
