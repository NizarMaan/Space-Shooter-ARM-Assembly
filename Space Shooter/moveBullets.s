.section .text

.globl MoveBullets 

// r0 = FrameBuffer
MoveBullets:
    push    {r4-r10, lr}

    ldr     r1, =GameState
    ldrb    r2, [r1]

    cmp     r2, #1
    bne     end


// moving bullets of the queens
queens:

    Temp            .req    r6
    BulletY         .req    r7
    QueenList       .req    r8
    SpecificQueen   .req    r9
    Counter         .req    r10
  
    ldr     QueenList, =QueenArray
    mov     Counter, #0

queensLoop:
    cmp     Counter, #2
    beq     knights

    ldr     SpecificQueen, [QueenList, Counter, LSL #2]
    ldr     Temp, [SpecificQueen, #8]

    cmp     Temp, #0                                        // if there's no bullet, then skip this unit
    addeq   Counter, #1
    beq     queensLoop

    // remove the previous bullet
    ldr     r1, [QueenList, Counter, LSL #2]
    bl      ClearAIBullet

    ldr     BulletY, [SpecificQueen, #16]                   // move bullet by 12 pixels
    ldr     r5, =BulletQueen
    ldr     r4, [r5]
    add     BulletY, r4
    str     BulletY, [SpecificQueen, #16]

    // Bullet reaching the end of the screen
    ldr     Temp, =720
    cmp     BulletY, Temp
    movge   Temp, #0
    strge   Temp, [SpecificQueen, #8]
    addge   Counter, #1
    bge     queensLoop


    // draw the new bullet
    ldr     r1, [QueenList, Counter, LSL #2]
    bl      DrawAIBullet

    add     Counter, #1

    b       queensLoop

// moving bullets of the knights
knights:
    .unreq      QueenList
    .unreq      SpecificQueen

    KnightList      .req    r8
    SpecificKnight  .req    r9

    ldr     KnightList, =KnightArray
    mov     Counter, #0

knightsLoop:
    cmp     Counter, #5
    beq     pawns

    ldr     SpecificKnight, [KnightList, Counter, LSL #2]
    ldr     r6, [SpecificKnight, #8]

    cmp     r6, #0
    addeq   Counter, #1
    beq     knightsLoop

    // remove the previous bullet
    ldr     r1, [KnightList, Counter, LSL #2]
    bl      ClearAIBullet

    ldr     BulletY, [SpecificKnight, #16]                           // move bullet by 9 pixels
    ldr     r5, =BulletKnight
    ldr     r4, [r5]
    add     BulletY, r4
    str     BulletY, [SpecificKnight, #16]

    // Bullet reaching the end of the screen
    ldr     Temp, =720
    cmp     BulletY, Temp
    movge   Temp, #0
    strge   Temp, [SpecificKnight, #8]
    addge   Counter, #1
    bge     knightsLoop


    // draw the new bullet
    ldr     r1, [KnightList, Counter, LSL #2]
    bl      DrawAIBullet

    add     Counter, #1

    b       knightsLoop


// moving bullets of the pawns
pawns:
    .unreq      KnightList
    .unreq      SpecificKnight

    PawnList      .req    r8
    SpecificPawn  .req    r9

    ldr     PawnList, =PawnArray
    mov     Counter, #0

pawnsLoop:
    cmp     Counter, #10
    beq     player

    ldr     SpecificPawn, [PawnList, Counter, LSL #2]
    ldr     r6, [SpecificPawn, #8]

    cmp     r6, #0
    addeq   Counter, #1
    beq     pawnsLoop

    // remove the previous bullet
    ldr     r1, [PawnList, Counter, LSL #2]
    bl      ClearAIBullet

    ldr     BulletY, [SpecificPawn, #16]                                 // move bullet by 6 pixels
    ldr     r5, =BulletPawn
    ldr     r4, [r5]
    add     BulletY, r4
    str     BulletY, [SpecificPawn, #16]

    // Bullet reaching the end of the screen
    ldr     Temp, =720
    cmp     BulletY, Temp
    movge   Temp, #0
    strge   Temp, [SpecificPawn, #8]
    addge   Counter, #1
    bge     pawnsLoop

    // draw the new bullet
    ldr     r1, [PawnList, Counter, LSL #2]
    bl      DrawAIBullet

    add     Counter, #1

    b       pawnsLoop

// moving bullet of player
player:
    .unreq      PawnList
    .unreq      SpecificPawn
    .unreq      Counter
   
    BulletActive    .req    r8
    BulletPosition  .req    r9
  
    ldr     BulletActive, =Bullet
    ldr     BulletPosition, =BulletPos

    ldr     r6, [BulletActive]

    cmp     r6, #0
    beq     end

    // remove the previous bullet
    bl      ClearPlayerBullet


    ldr     r3, [BulletPosition, #4]
    ldr     r6, =BulletMov
    ldr     r2, [r6]
    sub     r3, r2
    cmp     r3, #25
    movle   r4, #0
    strle   r4, [BulletActive]    
    ble     end
    str     r3, [BulletPosition, #4]

    // draw the new bullet
    bl      DrawPlayerBullet


end:
    pop     {r4-r10, lr}
    bx      lr

