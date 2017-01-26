.section .text

.globl PlayerShoot, AIShoot

PlayerShoot:
    push    {r4-r11, lr}

    ldr     r2, =PlayerPos          // x position of player
    ldr     r3, [r2]
    add     r3, #15         
    ldr     r2, =BulletPos          
    str     r3, [r2]                // x position of bullet is 15 pixels to the right of the left side of the square

    ldr     r2, =PlayerPos
    ldr     r3, [r2, #4]
    sub     r3, #15
    ldr     r2, =BulletPos          
    str     r3, [r2, #4]            // y position of bullet is 5 pixels above the top side of the square

    ldr     r2, =Bullet
    mov     r3, #1
    str     r3, [r2]

end:
    pop     {r4-r11, lr}
    bx      lr


AIShoot:
    push    {r4-r11, lr}

    UnitXCor        .req        r6
    UnitYCor        .req        r7
    UnitList        .req        r8
    SpecificUnit    .req        r9
    Counter         .req        r10
    Temp            .req        r11

queens:
    ldr     UnitList, =QueenArray
    mov     Counter, #0

queenLoop:
    cmp     Counter, #2
    beq     knights

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     Temp, [SpecificUnit, #20]
    cmp     Temp, #0
    addeq   Counter, #1
    beq     queenLoop                                   // if the unit is dead, don't shoot

    ldr     Temp, [SpecificUnit, #8]                    // if a bullet already exists, do nothing
    cmp     Temp, #1
    addeq   Counter, #1
    beq     queenLoop
    
    mov     Temp, #1
    str     Temp, [SpecificUnit, #8]                    // bullet now exists

    ldr     UnitXCor, [SpecificUnit]
    ldr     UnitYCor, [SpecificUnit, #4]

    add     Temp, UnitXCor, #13                         // bullet 13 pixels to the right 
    str     Temp, [SpecificUnit, #12]

    add     Temp, UnitYCor, #35        
    str     Temp, [SpecificUnit, #16]                   // bullet 5 pixels below

    add     Counter, #1
    b       queenLoop
                 
knights:
    ldr     UnitList, =KnightArray
    mov     Counter, #0

knightLoop:
    cmp     Counter, #5
    beq     pawns

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     Temp, [SpecificUnit, #20]
    cmp     Temp, #0
    addeq   Counter, #1
    beq     knightLoop                                  // if the unit is dead, don't shoot

    ldr     Temp, [SpecificUnit, #8]                    // if a bullet already exists, do nothing
    cmp     Temp, #1
    addeq   Counter, #1
    beq     knightLoop
    
    mov     Temp, #1
    str     Temp, [SpecificUnit, #8]                    // bullet now exists

    ldr     UnitXCor, [SpecificUnit]
    ldr     UnitYCor, [SpecificUnit, #4]

    add     Temp, UnitXCor, #15                         // bullet 15 pixels to the right 
    str     Temp, [SpecificUnit, #12]

    add     Temp, UnitYCor, #40        
    str     Temp, [SpecificUnit, #16]                   // bullet 5 pixels below

    add     Counter, #1
    b       knightLoop
                 

pawns:
    ldr     UnitList, =PawnArray
    mov     Counter, #0

pawnLoop:
    cmp     Counter, #10
    beq     end

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

    ldr     Temp, [SpecificUnit, #20]
    cmp     Temp, #0
    addeq   Counter, #1
    beq     pawnLoop                                   // if the unit is dead, don't shoot

    ldr     Temp, [SpecificUnit, #8]                    // if a bullet already exists, do nothing
    cmp     Temp, #1
    addeq   Counter, #1
    beq     pawnLoop
    
    mov     Temp, #1
    str     Temp, [SpecificUnit, #8]                    // bullet now exists

    ldr     UnitXCor, [SpecificUnit]
    ldr     UnitYCor, [SpecificUnit, #4]

    add     Temp, UnitXCor, #20                         // bullet 20 pixels to the right 
    str     Temp, [SpecificUnit, #12]

    add     Temp, UnitYCor, #50        
    str     Temp, [SpecificUnit, #16]                   // bullet 5 pixels below

    add     Counter, #1
    b       pawnLoop
                 



