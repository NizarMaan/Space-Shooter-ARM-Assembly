.section .text

.globl AIMovement

// movement of the ai boxes
AIMovement:
    push    {r4-r12, lr}

    UnitSpeed       .req        r5
    AmountMoved     .req        r6
    UnitXCor        .req        r7
    UnitList        .req        r8
    SpecificUnit    .req        r9
    Counter         .req        r10
    Temp            .req        r11
    Direction       .req        r12
    

pawns:
    mov     Counter, #0

    ldr     UnitList, =PawnArray

    ldr     Temp, =PawnSpeed
    ldr     UnitSpeed, [Temp]

    ldr     Temp, =PawnDirection
    ldr     Direction, [Temp]

    ldr     Temp, =PawnMov
    ldr     AmountMoved, [Temp]

    // if all the way right, move left
    cmp     AmountMoved, #10
    subeq   Direction, #1

    // if all the way left, move right
    cmp     AmountMoved, #-10
    addeq   Direction, #1

	ldr		Temp, =PawnDirection
	str		Direction, [Temp]

    // The direction the boxes are moving
    cmp     Direction, #1  
    addeq   AmountMoved, UnitSpeed
    subne   AmountMoved, UnitSpeed

	ldr		Temp, =PawnMov
    str     AmountMoved, [Temp]   

pawnsLoop:
    cmp     Counter, #10
    beq     knights

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

	// if the unit is dead it won't move
	ldr		Temp, [SpecificUnit, #20]
	cmp		Temp, #0
	addeq	Counter, #1
	beq		pawnsLoop

    // if the gamestate is not 1, the units won't move
    ldr     Temp, =GameState
    ldrb    r4, [Temp]
    cmp     r4, #1
    bne     KnightsLoop

    ldr     UnitXCor, [SpecificUnit]
    
    mov     r1, Counter
    bl      ClearPawn    

    cmp     Direction, #1                       // checking the direction
  
// move to the right
    addeq   UnitXCor, UnitSpeed
    streq   UnitXCor, [SpecificUnit]

//move to the left
    subne   UnitXCor, UnitSpeed
    strne   UnitXCor, [SpecificUnit] 

    mov     r1, Counter
    bl      DrawPawn

    add     Counter, #1
    b       pawnsLoop


knights:
    mov     Counter, #0

    ldr     UnitList, =KnightArray

    ldr     Temp, =KnightSpeed
    ldr     UnitSpeed, [Temp]

    ldr     Temp, =KnightDirection
    ldr     Direction, [Temp]

    ldr     Temp, =KnightMov
    ldr     AmountMoved, [Temp]

    // if all the way right, move left
    cmp     AmountMoved, #180
    subeq   Direction, #1

    // if all the way left, move right
    cmp     AmountMoved, #-180
    addeq   Direction, #1

	ldr		Temp, =KnightDirection
	str		Direction, [Temp]

    // The direction the boxes are moving
    cmp     Direction, #1  
    addeq   AmountMoved, UnitSpeed
    subne   AmountMoved, UnitSpeed

	ldr		Temp, =KnightMov
    str     AmountMoved, [Temp]   

KnightsLoop:
    cmp     Counter, #5
    beq     queens

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

	// if the unit is dead it won't move
	ldr		Temp, [SpecificUnit, #20]
	cmp		Temp, #0
	addeq	Counter, #1
	beq		KnightsLoop

    // if the gamestate is not 1, the units won't move
    ldr     Temp, =GameState
    ldrb    r4, [Temp]
    cmp     r4, #1
    bne     QueensLoop

    ldr     UnitXCor, [SpecificUnit]
    
    mov     r1, Counter
    bl      ClearKnight    

    cmp     Direction, #1                       // checking the direction
  
// move to the right
    addeq   UnitXCor, UnitSpeed
    streq   UnitXCor, [SpecificUnit]

//move to the left
    subne   UnitXCor, UnitSpeed
    strne   UnitXCor, [SpecificUnit] 

    mov     r1, Counter
    bl      DrawKnight

    add     Counter, #1
    b       KnightsLoop


queens:
    mov     Counter, #0

    ldr     UnitList, =QueenArray

    ldr     Temp, =QueenSpeed
    ldr     UnitSpeed, [Temp]

    ldr     Temp, =QueenDirection
    ldr     Direction, [Temp]

    ldr     Temp, =QueenMov
    ldr     AmountMoved, [Temp]

    // if all the way right, move left
    cmp     AmountMoved, #75
    subeq   Direction, #1

    // if all the way left, move right
    cmp     AmountMoved, #-75
    addeq   Direction, #1

	ldr		Temp, =QueenDirection
	str		Direction, [Temp]

    // The direction the boxes are moving
    cmp     Direction, #1  
    addeq   AmountMoved, UnitSpeed
    subne   AmountMoved, UnitSpeed

	ldr		Temp, =QueenMov
    str     AmountMoved, [Temp]   

QueensLoop:
    cmp     Counter, #2
    beq     end

    ldr     SpecificUnit, [UnitList, Counter, LSL #2]

	// if the unit is dead it won't move
	ldr		Temp, [SpecificUnit, #20]
	cmp		Temp, #0
	addeq	Counter, #1
	beq		QueensLoop

    // if the gamestate is not 1, the units won't move
    ldr     Temp, =GameState
    ldrb    r4, [Temp]
    cmp     r4, #1
    bne     end

    ldr     UnitXCor, [SpecificUnit]
    
    mov     r1, Counter
    bl      ClearQueen    

    cmp     Direction, #1                       // checking the direction
  
// move to the right
    addeq   UnitXCor, UnitSpeed
    streq   UnitXCor, [SpecificUnit]

//move to the left
    subne   UnitXCor, UnitSpeed
    strne   UnitXCor, [SpecificUnit] 

    mov     r1, Counter
    bl      DrawQueen

    add     Counter, #1
    b       QueensLoop

end:
	.unreq    UnitSpeed      
	.unreq    AmountMoved    
	.unreq    UnitXCor        
	.unreq    UnitList       
	.unreq    SpecificUnit    
	.unreq    Counter         
	.unreq    Temp            
	.unreq    Direction       

    pop     {r4-r12, lr}
    bx      lr
