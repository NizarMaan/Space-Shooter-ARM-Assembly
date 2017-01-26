.section .text

.globl  HitDetection

//r0 = FrameBuffer
HitDetection:
    push    {r4-r12, lr}

    // checking to see if a player bullet actually exists
    ldr     r2, =Bullet
    ldr     r3, [r2]
    cmp     r3, #1

    bleq    playerBullet

aiBulletsCheck:
    bl      aiBullets

end:
    pop     {r4-r12, lr}
    bx      lr


playerBullet:
    push    {lr}

    BulletDimension .req        r2
    UnitDimension   .req        r3
    BulletXCor      .req        r4
    BulletYCor      .req        r5
    UnitXCor        .req        r6
    UnitYCor        .req        r7
    UnitList        .req        r8
    SpecificUnit    .req        r9
    Counter         .req        r10
    Temp            .req        r11

    ldr     Temp, =BulletPos
    ldr     BulletXCor, [Temp]
    ldr     BulletYCor, [Temp, #4]

obstacle:
    ldr     UnitList, =ObstacleArray
    mov     Counter, #0

obstacleLoop:
    cmp     Counter, #3
    beq     pawn

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     r6, [SpecificUnit, #8]                              // checking to see if the obstacle has a health above 0 first
    cmp     r6, #0
    addeq   Counter, #1
    beq     obstacleLoop

    ldr     UnitXCor, [SpecificUnit]
    ldr     UnitYCor, [SpecificUnit, #4]

    ldr     Temp, =ObstacleDim
    ldr     UnitDimension, [Temp]

    // checking x coordinates
    add     Temp, UnitXCor, UnitDimension                       // obstacle is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   Counter, #1
    bgt     obstacleLoop

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    add     Temp, BulletXCor, BulletDimension                   // obstacle is to the right of the rightest side of the bullet 
    cmp     Temp, UnitXCor
    addlt   Counter, #1
    blt     obstacleLoop

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // obstacle is to the bottom of the bottom side of bullet           
    cmp     Temp, UnitYCor                            
    addlt   Counter, #1    
    blt     obstacleLoop

    ldr     Temp, [SpecificUnit, #8]
    add     Temp, UnitYCor, Temp                               // obstacle is above the top side of bullet
    ldr     r4, =BulletMov
    ldr     r3, [r4]
    add     Temp, r3
    cmp     BulletYCor, Temp
    addgt   Counter, #1
    bgt     obstacleLoop

    ldr     Temp, =Bullet
    mov     r2, #0
    str     r2, [Temp]

    bl      ClearPlayerBullet


pawn:
    ldr     UnitList, =PawnArray
    mov     Counter, #0

pawnLoop:
    cmp     Counter, #10
    beq     knight

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     r6, [SpecificUnit, #20]                              // checking to see if the pawn has a health above 0 first
    cmp     r6, #0
    addeq   Counter, #1
    beq     pawnLoop

    ldr     UnitXCor, [SpecificUnit]
    ldr     UnitYCor, [SpecificUnit, #4]

    ldr     Temp, =PawnDim
    ldr     UnitDimension, [Temp]

    // checking x coordinates
    add     Temp, UnitXCor, UnitDimension                       // unit is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   Counter, #1
    bgt     pawnLoop

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    add     Temp, BulletXCor, BulletDimension                   // unit is to the right of the rightest side of the bullet 
    cmp     Temp, UnitXCor
    addlt   Counter, #1
    blt     pawnLoop

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // unit is to the bottom of the bottom side of bullet           
    cmp     Temp, UnitYCor                            
    addlt   Counter, #1    
    blt     pawnLoop

    add     Temp, UnitYCor, UnitDimension                       // unit is above the top side of bullet
    ldr     r4, =BulletMov
    ldr     r3, [r4]
    add     Temp, r3
    cmp     BulletYCor, Temp
    addgt   Counter, #1
    bgt     pawnLoop

    ldr     Temp, =Bullet                                       // the bullet no longer exists
    mov     r2, #0
    str     r2, [Temp]

    ldr     Temp, [SpecificUnit, #20]                           // reducing health of object by 1
    sub     Temp, #1
    str     Temp, [SpecificUnit, #20]

    cmp     Temp, #0

    moveq   r1, #1                                              // Score Increase
    moveq   r2, #2                                              // Unit killed = Pawn
    bleq    ModifyScore

    moveq   r1, Counter
    bleq    ClearPawn                                           // removes the pawn if health = 0

    bl      ClearPlayerBullet

    b       endOfLoops

knight:
    ldr     UnitList, =KnightArray
    mov     Counter, #0

knightLoop:
    cmp     Counter, #5
    beq     queen

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     r6, [SpecificUnit, #20]                              // checking to see if the knight has a health above 0 first
    cmp     r6, #0
    addeq   Counter, #1
    beq     knightLoop

    ldr     UnitXCor, [SpecificUnit]
    ldr     UnitYCor, [SpecificUnit, #4]

    ldr     Temp, =KnightDim
    ldr     UnitDimension, [Temp]

    // checking x coordinates
    add     Temp, UnitXCor, UnitDimension                       // unit is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   Counter, #1
    bgt     knightLoop

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    add     Temp, BulletXCor, BulletDimension                   // unit is to the right of the rightest side of the bullet 
    cmp     Temp, UnitXCor
    addlt   Counter, #1
    blt     knightLoop

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // unit is to the bottom of the bottom side of bullet           
    cmp     Temp, UnitYCor                                
    addlt   Counter, #1    
    blt     knightLoop

    add     Temp, UnitYCor, UnitDimension                       // unit is above the top side of bullet
    ldr     r4, =BulletMov
    ldr     r3, [r4]
    add     Temp, r3
    cmp     BulletYCor, Temp
    addgt   Counter, #1
    bgt     knightLoop

    ldr     Temp, =Bullet
    mov     r2, #0
    str     r2, [Temp]

    ldr     Temp, [SpecificUnit, #20]
    sub     Temp, #1
    str     Temp, [SpecificUnit, #20]

    cmp     Temp, #0

    moveq   r1, #1                                               // Score Increase
    moveq   r2, #1                                               // Unit killed = Knight 
    bleq    ModifyScore

    moveq   r1, Counter
    bleq    ClearKnight                                          // removes the knight if health = 0

    bl      ClearPlayerBullet

    b       endOfLoops

queen:
    ldr     UnitList, =QueenArray
    mov     Counter, #0

queenLoop:
    cmp     Counter, #2
    beq     endOfLoops

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     r6, [SpecificUnit, #20]                              // checking to see if the queen has a health above 0 first
    cmp     r6, #0
    addeq   Counter, #1
    beq     queenLoop

    ldr     UnitXCor, [SpecificUnit]
    ldr     UnitYCor, [SpecificUnit, #4]

    ldr     Temp, =QueenDim
    ldr     UnitDimension, [Temp]

    // checking x coordinates
    add     Temp, UnitXCor, UnitDimension                       // unit is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   Counter, #1
    bgt     queenLoop

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    add     Temp, BulletXCor, BulletDimension                   // unit is to the right of the rightest side of the bullet 
    cmp     Temp, UnitXCor
    addlt   Counter, #1
    blt     queenLoop

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // unit is to the bottom of the bottom side of bullet           
    cmp     Temp, UnitYCor                                
    addlt   Counter, #1    
    blt     queenLoop

    add     Temp, UnitYCor, UnitDimension                       // unit is above the top side of bullet
    ldr     r4, =BulletMov
    ldr     r3, [r4]
    add     Temp, r3
    cmp     BulletYCor, Temp
    addgt   Counter, #1
    bgt     queenLoop

    ldr     Temp, =Bullet                                       // Bullet no longer exists
    mov     r2, #0
    str     r2, [Temp]

    ldr     Temp, [SpecificUnit, #20]                           // Reducing health of the object by 1
    sub     Temp, #1
    str     Temp, [SpecificUnit, #20]


    cmp     Temp, #0

    moveq   r1, #1                                              // Score Increase
    moveq   r2, #0                                              // Unit killed = Queen    
    bleq    ModifyScore

    moveq   r1, Counter
    bleq    ClearQueen                                          // removes the queen if health = 0

    bl      ClearPlayerBullet

endOfLoops:
    .unreq        Temp
    .unreq        BulletDimension
    .unreq        UnitDimension
    .unreq        BulletXCor
    .unreq        BulletYCor
    .unreq        UnitXCor
    .unreq        UnitYCor
    .unreq        UnitList
    .unreq        SpecificUnit
    .unreq        Counter

    pop     {lr}    
    bx      lr


aiBullets:
    push    {lr}

    Temp            .req        r1
    BulletDimension .req        r2
    PlayerDimension .req        r3
    BulletXCor      .req        r4
    BulletYCor      .req        r5
    PlayerXCor      .req        r6
    PlayerYCor      .req        r7
    UnitList        .req        r8
    SpecificUnit    .req        r9
    Counter         .req        r10
    

    ldr     Temp, =PlayerPos
    ldr     PlayerXCor, [Temp]
    ldr     PlayerYCor, [Temp, #4]

    ldr     Temp, =PlayerDim
    ldr     PlayerDimension, [Temp]
 
pawnAI:
    ldr     UnitList, =PawnArray
    mov     Counter, #0

pawnLoopAI:
    cmp     Counter, #10
    beq     knightAI

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     Temp, [SpecificUnit, #8]
    cmp     Temp, #0
    addeq   Counter, #1
    beq     pawnLoopAI

    ldr     BulletXCor, [SpecificUnit, #12]
    ldr     BulletYCor, [SpecificUnit, #16]

    // obstacle check
    ldr     Temp, =550
    cmp     BulletYCor, Temp

    ldrgt   r1, [UnitList, Counter, LSL #2]
    blgt    obstacleHitDetection

    cmp     r1, #1                                              // bullet hit an obstacle
    addeq   Counter, #1
    beq     pawnLoopAI

    // player hit checking
    // checking x coordinates
    add     Temp, PlayerXCor, PlayerDimension                   // player is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   Counter, #1
    bgt     pawnLoopAI

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    add     Temp, BulletXCor, BulletDimension                   // player is to the right of the rightest side of the bullet 
    cmp     Temp, PlayerXCor
    addlt   Counter, #1
    blt     pawnLoopAI

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // if the bottom of the bullet has hit the player           
    cmp     Temp, PlayerYCor                            
    addlt   Counter, #1    
    blt     pawnLoopAI

    add     Temp, PlayerYCor, PlayerDimension                    // if the top of the bullet has hit the player
    ldr     r11, =BulletMov
    ldr     r12, [r11]
    add     Temp, r12
    cmp     BulletYCor, Temp
    addgt   Counter, #1
    bgt     pawnLoopAI
                                      
    mov     Temp, #0                                              // the bullet no longer exists
    str     Temp, [SpecificUnit, #8]

    mov     r1, #0                                                // Score Decrease
    bl      ModifyScore

    ldr     r1, [UnitList, Counter, LSL #2]
    bl      ClearAIBullet

    add     Counter, #1
    b       pawnLoopAI


knightAI:
    ldr     UnitList, =KnightArray
    mov     Counter, #0

knightLoopAI:
    cmp     Counter, #5
    beq     queenAI

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     Temp, [SpecificUnit, #8]
    cmp     Temp, #0
    addeq   Counter, #1
    beq     knightLoopAI

    ldr     BulletXCor, [SpecificUnit, #12]
    ldr     BulletYCor, [SpecificUnit, #16]

    // pawn check
    ldr   r1, [UnitList, Counter, LSL #2]
    bl    pawnHitDetection

    // obstacle check
    ldr     Temp, =550
    cmp     BulletYCor, Temp

    ldrgt   r1, [UnitList, Counter, LSL #2]
    blgt    obstacleHitDetection

    cmp     r1, #1                                              // bullet hit an obstacle
    addeq   Counter, #1
    beq     knightLoopAI

    //Player hit checking
    // checking x coordinates
    add     Temp, PlayerXCor, PlayerDimension                   // player is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   Counter, #1
    bgt     knightLoopAI

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    add     Temp, BulletXCor, BulletDimension                   // player is to the right of the rightest side of the bullet 
    cmp     Temp, PlayerXCor
    addlt   Counter, #1
    blt     knightLoopAI

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // if the bottom of the bullet has hit the player           
    cmp     Temp, PlayerYCor                            
    addlt   Counter, #1    
    blt     knightLoopAI

    add     Temp, PlayerYCor, PlayerDimension                     // if the top of the bullet has hit the player
    ldr     r11, =BulletMov
    ldr     r12, [r11]
    add     Temp, r12
    cmp     BulletYCor, Temp
    addgt   Counter, #1
    bgt     knightLoopAI
                                      
    mov     Temp, #0                                              // the bullet no longer exists
    str     Temp, [SpecificUnit, #8]

    mov     r1, #0                                                // Score Decrease
    bl      ModifyScore

    ldr     r1, [UnitList, Counter, LSL #2]
    bl      ClearAIBullet

    add     Counter, #1
    b       knightLoopAI


queenAI:
    ldr     UnitList, =QueenArray
    mov     Counter, #0

queenLoopAI:
    cmp     Counter, #2
    beq     endOfLoopsAI

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     Temp, [SpecificUnit, #8]
    cmp     Temp, #0
    addeq   Counter, #1
    beq     queenLoopAI

    ldr     BulletXCor, [SpecificUnit, #12]
    ldr     BulletYCor, [SpecificUnit, #16]

    // pawn check
    ldr     r1, [UnitList, Counter, LSL #2]
    bl      pawnHitDetection

    // knight check
    ldr     r1, [UnitList, Counter, LSL #2]
    bl      knightHitDetection

    // obstacle check
    ldr     Temp, =550
    cmp     BulletYCor, Temp

    ldrgt   r1, [UnitList, Counter, LSL #2]
    blgt    obstacleHitDetection

    cmp     r1, #1                                              // bullet hit an obstacle
    addeq   Counter, #1
    beq     queenLoopAI

    //Player hit checking
    // checking x coordinates
    add     Temp, PlayerXCor, PlayerDimension                   // player is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   Counter, #1
    bgt     queenLoopAI

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    add     Temp, BulletXCor, BulletDimension                   // player is to the right of the rightest side of the bullet 
    cmp     Temp, PlayerXCor
    addlt   Counter, #1
    blt     queenLoopAI

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // if the bottom of the bullet has hit the player           
    cmp     Temp, PlayerYCor                            
    addlt   Counter, #1    
    blt     queenLoopAI

    add     Temp, PlayerYCor, PlayerDimension                     // if the top of the bullet has hit the player
    ldr     r11, =BulletMov
    ldr     r12, [r11]
    add     Temp, r12
    cmp     BulletYCor, Temp
    addgt   Counter, #1
    bgt     queenLoopAI
                                      
    mov     Temp, #0                                              // the bullet no longer exists
    str     Temp, [SpecificUnit, #8]

    mov     r1, #0                                                // Score Decrease
    bl      ModifyScore

    ldr     r1, [UnitList, Counter, LSL #2]
    bl      ClearAIBullet

    add     Counter, #1
    b       queenLoopAI


endOfLoopsAI:
    .unreq        Temp
    .unreq        BulletDimension
    .unreq        PlayerDimension
    .unreq        BulletXCor
    .unreq        BulletYCor
    .unreq        PlayerXCor
    .unreq        PlayerYCor
    .unreq        UnitList
    .unreq        SpecificUnit
    .unreq        Counter

    pop     {lr}    
    bx      lr


//r1 = the unit who shot the bullet
obstacleHitDetection:
    push    {r2-r12, lr}


    Temp                .req        r4
    BulletDimension     .req        r5
    BulletXCor          .req        r6
    BulletYCor          .req        r7
    ObstacleCounter     .req        r8
    SpecificObstacle    .req        r9
    ObstacleList        .req        r10
    SpecificUnit        .req        r11

    push    {r1}
    pop     {SpecificUnit}

    ldr     ObstacleList, =ObstacleArray

    ldr     BulletXCor, [SpecificUnit, #12]
    ldr     BulletYCor, [SpecificUnit, #16]

    mov     ObstacleCounter, #0


obstacleLoopAI:
    cmp     ObstacleCounter, #3
    beq     obstacleLoopEnd

    ldr     SpecificObstacle, [ObstacleList, ObstacleCounter, LSL #2]

    ldr     Temp, [SpecificObstacle, #8]
    cmp     Temp, #0
    addeq   ObstacleCounter, #1
    beq     obstacleLoopAI


    // checking x coordinates
    ldr     Temp, [SpecificObstacle]
    ldr     r2, =ObstacleDim
    ldr     r3, [r2]
    add     Temp, r3                                           // obstacle is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   ObstacleCounter, #1
    bgt     obstacleLoopAI

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    ldr     r2, [SpecificObstacle]

    add     Temp, BulletXCor, BulletDimension                   // obstacle is to the right of the rightest side of the bullet 
    cmp     Temp, r2
    addlt   ObstacleCounter, #1
    blt     obstacleLoopAI

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // if the bottom of the bullet is above the obstacle   
    ldr     r2, [SpecificObstacle, #4]        
    cmp     Temp, r2                          
    addlt   ObstacleCounter, #1    
    blt     obstacleLoopAI

    ldr     Temp, [SpecificObstacle, #8]

    add     Temp, r2                                          // if the top of the bullet is above the obstacle
    ldr     r3, =BulletMov
    ldr     r12, [r3]
    add     Temp, r12
    cmp     BulletYCor, Temp
    addgt   ObstacleCounter, #1
    bgt     obstacleLoopAI

    mov     Temp, #0                                              // the bullet no longer exists
    str     Temp, [SpecificUnit, #8]

    push    {SpecificUnit}
    pop     {r1}
    bl      ClearAIBullet

    ldr     r1, [ObstacleList, ObstacleCounter, LSL #2]
    bl      ClearObstacle

    ldr     Temp, [SpecificObstacle, #8]
    sub     Temp, #1
    str     Temp, [SpecificObstacle, #8]

    cmp     Temp, #0

    ldrne   r1, [ObstacleList, ObstacleCounter, LSL #2]
    blne    DrawObstacle

    mov     r1, #1

obstacleLoopEnd:
    .unreq          Temp         
    .unreq          BulletDimension
    .unreq          BulletXCor
    .unreq          BulletYCor       
    .unreq          ObstacleCounter
    .unreq          SpecificObstacle   
    .unreq          ObstacleList       
    .unreq          SpecificUnit       

    pop     {r2-r12, lr}
    bx      lr


// ai hitting the pawns
pawnHitDetection:
    push    {r2-r12, lr}

    Temp                .req        r4
    BulletDimension     .req        r5
    BulletXCor          .req        r6
    BulletYCor          .req        r7
    Counter             .req        r8
    UnitThatFired       .req        r9
    UnitList            .req        r10
    SpecificUnit        .req        r11

    push    {r1}
    pop     {UnitThatFired}

    ldr     UnitList, =PawnArray

    ldr     BulletXCor, [UnitThatFired, #12]
    ldr     BulletYCor, [UnitThatFired, #16]

    mov     Counter, #0

// r1 = the unit who shot the bullet
pawnHitLoopAI:
    cmp     Counter, #10
    beq     pawnHitLoopAIEnd

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     Temp, [SpecificUnit, #8]
    cmp     Temp, #0
    addeq   Counter, #1
    beq     pawnHitLoopAI


    // checking x coordinates
    ldr     Temp, [SpecificUnit]
    ldr     r2, =PawnDim
    ldr     r3, [r2]
    add     Temp, r3                                           // obstacle is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   Counter, #1
    bgt     pawnHitLoopAI

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    ldr     r2, [SpecificUnit]

    add     Temp, BulletXCor, BulletDimension                   // obstacle is to the right of the rightest side of the bullet 
    cmp     Temp, r2
    addlt   Counter, #1
    blt     pawnHitLoopAI

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // if the bottom of the bullet has hit the player
    add     Temp, #10   
    ldr     r2, [SpecificUnit, #4]        
    cmp     Temp, r2                          
    addlt   Counter, #1    
    blt     pawnHitLoopAI

    ldr     Temp, [SpecificUnit, #8]

    add     Temp, r2                                          // if the top of the bullet has hit the player
    ldr     r3, =BulletPawn
    ldr     r12, [r3]
    add     Temp, r12
    cmp     BulletYCor, Temp
    addgt   Counter, #1
    bgt     pawnHitLoopAI

    mov     Temp, #0                                              // the bullet no longer exists
    str     Temp, [UnitThatFired, #8]

    push    {UnitThatFired}
    pop     {r1}
    bl      ClearAIBullet

pawnHitLoopAIEnd:
    .unreq          Temp           
    .unreq          BulletDimension  
    .unreq          BulletXCor    
    .unreq          BulletYCor       
    .unreq          Counter           
    .unreq          UnitThatFired    
    .unreq          UnitList        
    .unreq          SpecificUnit

    pop     {r2-r12, lr}
    bx      lr



// ai hitting the knights
//r1 = unit that fired the bullet
knightHitDetection:
    push    {r2-r12, lr}

    Temp                .req        r4
    BulletDimension     .req        r5
    BulletXCor          .req        r6
    BulletYCor          .req        r7
    Counter             .req        r8
    UnitThatFired       .req        r9
    UnitList            .req        r10
    SpecificUnit        .req        r11

    push    {r1}
    pop     {UnitThatFired}

    ldr     UnitList, =KnightArray

    ldr     BulletXCor, [UnitThatFired, #12]
    ldr     BulletYCor, [UnitThatFired, #16]

    mov     Counter, #0

// r1 = the unit who shot the bullet
knightHitLoopAI:
    cmp     Counter, #5
    beq     knightHitLoopAIEnd

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     Temp, [SpecificUnit, #8]
    cmp     Temp, #0
    addeq   Counter, #1
    beq     knightHitLoopAI


    // checking x coordinates
    ldr     Temp, [SpecificUnit]
    ldr     r2, =KnightDim
    ldr     r3, [r2]
    add     Temp, r3                                           // obstacle is to the left of the leftest side of the bullet
    cmp     BulletXCor, Temp
    addgt   Counter, #1
    bgt     knightHitLoopAI

    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp]

    ldr     r2, [SpecificUnit]

    add     Temp, BulletXCor, BulletDimension                   // obstacle is to the right of the rightest side of the bullet 
    cmp     Temp, r2
    addlt   Counter, #1
    blt     knightHitLoopAI

    // checking y coordinates
    ldr     Temp, =BulletDim
    ldr     BulletDimension, [Temp, #4]
    
    add     Temp, BulletYCor, BulletDimension                   // if the bottom of the bullet has hit the player
    add     Temp, #5   
    ldr     r2, [SpecificUnit, #4]        
    cmp     Temp, r2                          
    addlt   Counter, #1    
    blt     knightHitLoopAI

    ldr     Temp, [SpecificUnit, #8]

    add     Temp, r2                                          // if the top of the bullet has hit the player
    ldr     r3, =BulletKnight
    ldr     r12, [r3]
    add     Temp, r12
    cmp     BulletYCor, Temp
    addgt   Counter, #1
    bgt     knightHitLoopAI

    mov     Temp, #0                                              // the bullet no longer exists
    str     Temp, [UnitThatFired, #8]

    push    {UnitThatFired}
    pop     {r1}
    bl      ClearAIBullet

knightHitLoopAIEnd:
    .unreq          Temp           
    .unreq          BulletDimension  
    .unreq          BulletXCor    
    .unreq          BulletYCor       
    .unreq          Counter           
    .unreq          UnitThatFired    
    .unreq          UnitList        
    .unreq          SpecificUnit

    pop     {r2-r12, lr}
    bx      lr

