.section .text

.globl Reset

Reset:

InitializeScreen:
    push    {r4-r10, lr}

//Queens
    queenMov        .req    r6
    queenSpeed      .req    r7
    queenDirection  .req    r8
    QueenList       .req    r9
    SpecificQueen   .req    r10

    ldr     queenDirection, =QueenDirection
    ldr     queenSpeed, =QueenSpeed
    ldr     queenMov,   =QueenMov
    
    mov     r1,     #0
    str     r1,     [queenMov]
    str     r1,     [queenDirection] 
    mov     r1,     #5
    str     r1,     [queenSpeed]   
       
    ldr     QueenList, =QueenArray

//Queen #1
    ldr     SpecificQueen, [QueenList]
    ldr 	r1, =300 
   	str   	r1, [SpecificQueen] 
   
   	ldr 	r2, =50 
   	str 	r2, [SpecificQueen, #4]  

   	ldr		r3, =0
   	str 	r3, [SpecificQueen, #8] 

   	ldr 	r4, =0
   	str 	r4, [SpecificQueen, #12] 

   	ldr 	r5, =0
   	str 	r5, [SpecificQueen, #16] 

	ldr		r5, =5                
	str     r5, [SpecificQueen, #20]    

//Queen #2
    ldr     SpecificQueen, [QueenList, #4]
    ldr 	r1, =620 
   	str   	r1, [SpecificQueen, #4] 
   
   	ldr 	r2, =50 
   	str 	r2, [SpecificQueen, #4]  

   	ldr		r3, =0
   	str 	r3, [SpecificQueen, #8] 

   	ldr 	r4, =0
   	str 	r4, [SpecificQueen, #12] 

   	ldr 	r5, =0
   	str 	r5, [SpecificQueen, #16] 

	ldr		r6, =5                
	str     r6, [SpecificQueen, #20]                                 // 5th argument = dimension
        
    .unreq      queenMov        
    .unreq      queenSpeed      
    .unreq      queenDirection    
    .unreq      QueenList
    .unreq      SpecificQueen

//Knights
    knightMov       .req    r5
    knightSpeed     .req    r6
    knightDirection .req    r7
    counter         .req    r8
    KnightList      .req    r9
    SpecificKnight  .req    r10

    ldr     knightDirection, =KnightDirection
    ldr     knightSpeed, =KnightSpeed
    ldr     knightMov,   =KnightMov
    
    mov     r1, #0
    str     r1,     [knightMov]
    str     r1,     [knightDirection]
    mov     r1, #3
    str     r1,    [knightSpeed]
    
    ldr     KnightList, =KnightArray

    mov     counter, #0         // keeping count of number of knights made

    ldr 	r1, =220 

knightCreate:
    ldr     SpecificKnight, [KnightList, counter, lsl #2]

    str     r1, [SpecificKnight]

    ldr 	r2, =100
    str     r2, [SpecificKnight, #4]

    ldr		r3, =0
    str     r3, [SpecificKnight, #8]

    ldr		r4, =0
    str     r4, [SpecificKnight, #12]

    ldr		r5, =0
    str     r5, [SpecificKnight, #16]

    ldr		r6, =3
    str     r6, [SpecificKnight, #20]

    add		r1, #120 
    add     counter, #1         // counter++

    cmp     counter, #5         // making 5 knights
    blt     knightCreate

    .unreq  knightDirection
    .unreq  knightSpeed
    .unreq  knightMov
    .unreq  KnightList
    .unreq  SpecificKnight
    
//Pawns
    pawnMov       .req    r5
    pawnSpeed     .req    r6
    pawnDirection .req    r7
    PawnList      .req    r9
    SpecificPawn  .req    r10

    ldr     pawnDirection, =PawnDirection
    ldr     pawnSpeed, =PawnSpeed
    ldr     pawnMov,   =PawnMov
    
    mov     r1, #0
    str     r1,     [pawnMov]
    str     r1,     [pawnDirection]
    mov     r1, #1
    str     r1,    [pawnSpeed]

    ldr     PawnList, =PawnArray
    mov     counter, #0         // keeping count of number of pawns made
    ldr		r1, =25

pawnCreate:
    ldr     SpecificPawn, [PawnList, counter, lsl #2]
    
    str     r1, [SpecificPawn]

    ldr		r2, =200
    str		r2, [SpecificPawn, #4]

    ldr		r3, =0
    str		r3, [SpecificPawn, #8]

    ldr		r4, =0
    str		r4, [SpecificPawn, #12]

    ldr		r3, =0
    str		r3, [SpecificPawn, #16]

    ldr		r3, =1
    str		r3, [SpecificPawn, #20]

    add     counter, #1         // counter++
    add     r1, #100
    cmp     counter, #10        // making 10 pawns
    blt     pawnCreate


    .unreq  pawnDirection
    .unreq  pawnSpeed
    .unreq  pawnMov
    .unreq  PawnList
    .unreq  SpecificPawn

//Player
    PlayerPosition   .req    r10

    ldr     PlayerPosition, =PlayerPos

    ldr		r1, =450
	str		r1, [PlayerPosition]			// x-coordinate
	
	ldr		r2, =700
	str		r2, [PlayerPosition, #4]        // y - coordinate

    .unreq      PlayerPosition

//Obstacles
    ObstacleList        .req    r9
    SpecificObstacle    .req    r10

    ldr     ObstacleList, =ObstacleArray
    mov     counter, #0            

    ldr 	r1, =125
//Obstacles
obstacleCreate:
    ldr     SpecificObstacle, [ObstacleList, counter, LSL #2]
    str     r1, [SpecificObstacle]

    ldr		r2, =575
    str     r2, [SpecificObstacle, #4]

    mov		r3, #15
    str     r3, [SpecificObstacle, #8] 

    add     counter, #1    

    add		r1, #300

    cmp     counter, #3        // making 3 obstacles
    bne     obstacleCreate

    .unreq ObstacleList
    .unreq SpecificObstacle

    BulletPosition   .req    r10

    ldr     BulletPosition, =BulletPos

    ldr		r1, =0
	str		r1, [BulletPosition]			// x-coordinate
	
	ldr		r2, =0
	str		r2, [BulletPosition, #4]        // y - coordinate

    .unreq      BulletPosition
    .unreq      counter 

    State   .req r10

    ldr    State, =GameState

    mov     r1, #1
    strb    r1, [State]

    .unreq  State


    PauseMenu .req r10

    ldr    PauseMenu, =PauseMenuPointer

    mov     r1, #0
    strb    r1, [PauseMenu]

    .unreq  PauseMenu

    Points  .req r10 

    ldr    Points, =Score

    mov     r1, #'0'
    strb    r1, [Points]
    strb    r1, [Points, #2]
    mov     r1, #'5'
    strb    r1, [Points, #1]

    .unreq Points

end:
    pop     {r4-r10, lr}
    bx      lr     
