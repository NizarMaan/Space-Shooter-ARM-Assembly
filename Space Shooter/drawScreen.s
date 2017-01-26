.section .text

.globl DrawScreen

DrawScreen:

//frameBuffer = r0
InitializeScreen:
    push    {r4-r10, lr}

//Queens
    QueenHealth     .req    r7
    QueenList       .req    r8
    SpecificQueen   .req    r9
    QueenDimension  .req    r10
  
    ldr     QueenList, =QueenArray
    ldr     QueenDimension, =QueenDim

//Queen #1
    ldr     SpecificQueen, [QueenList]
    ldr     QueenHealth,   [SpecificQueen, #20] //this Queen's health
    cmp     QueenHealth,    #0                  // draw if health is above 0
    beq     queenTwo

    ldr		r1, [SpecificQueen]                 // x-coordinate
	ldr		r2, [SpecificQueen, #4]             // y-coordinate
	ldr 	r3, =0x780F                         // colour     
	ldr		r4, [QueenDimension]                // dimension
	push	{r4}                                // 5th argument = dimension

	bl   	DrawSquare                          //draws square
queenTwo:
//Queen #2
    ldr     SpecificQueen, [QueenList, #4]
    ldr     QueenHealth,   [SpecificQueen, #20] //this Queen's health
    cmp     QueenHealth,    #0                  // draw if health is above 0
    beq     knights

    ldr		r1, [SpecificQueen]                 // x-coordinate
	ldr		r2, [SpecificQueen, #4]             // y-coordinate
	ldr 	r3, =0x780F                         // colour     
	ldr		r4, [QueenDimension]                // dimension
	push	{r4}                                // 5th argument = dimension

    bl      DrawSquare

    .unreq      QueenHealth
    .unreq      QueenList
    .unreq      SpecificQueen
    .unreq      QueenDimension

knights:
//Knights
    counter         .req    r6
    KnightHealth    .req    r7
    KnightList      .req    r8
    SpecificKnight  .req    r9
    KnightDimension .req    r10
    
    ldr     r4,    =KnightDim
    ldr     KnightDimension,    [r4]
    ldr     KnightList, =KnightArray
    mov     counter, #0                         // keeping count of number of knights made

knightCreate:
    cmp     counter, #5
    beq     pawn

    ldr     SpecificKnight, [KnightList, counter, lsl #2]
    ldr     KnightHealth,   [SpecificKnight, #20]   //this Knight's health  
    cmp     KnightHealth, #0                //Draw knight if health > 0
    addeq   counter, #1
    beq     knightCreate

    ldr     r1, [SpecificKnight]
    ldr     r2, [SpecificKnight, #4]
	ldr 	r3, =0xFFFF                         // white knights

	push	{KnightDimension}                                // send r4 as 5th argument

	bl      DrawSquare
    
    add     counter, #1         // counter++

    b       knightCreate

    .unreq  KnightHealth
    .unreq  KnightList
    .unreq  SpecificKnight
    .unreq  KnightDimension

pawn:
//Pawns
    counter       .req    r5
    PawnHealth    .req    r7
    PawnList      .req    r8
    SpecificPawn  .req    r9
    PawnDimension .req    r10

    ldr     PawnDimension,    =PawnDim
    ldr     r4,    [PawnDimension]
    ldr     PawnList, =PawnArray
    mov     counter, #0         // keeping count of number of pawns made

pawnCreate:
    cmp     counter, #11
    beq     player

    ldr     SpecificPawn, [PawnList, counter, lsl #2]
    ldr     PawnHealth, [SpecificPawn, #20]
    cmp     PawnHealth, #0      //Draw pawn if health > 0
    addeq   counter, #1
    beq     pawnCreate

    ldr     r1, [SpecificPawn]
    ldr     r2, [SpecificPawn, #4]

	ldr 	r3, =0xF800         // red pawns

	push	{r4}                // send r4 as 5th argument


	bl      DrawSquare
    
    add     counter, #1         // counter++

    beq     pawnCreate

    .unreq  PawnHealth
    .unreq  PawnList
    .unreq  SpecificPawn
    .unreq  PawnDimension

player:
//Player
    PlayerPosition   .req    r9
    PlayerDimension  .req    r10

    ldr     PlayerPosition, =PlayerPos
    ldr     PlayerDimension, =PlayerDim

	ldr		r1, [PlayerPosition]			// x-coordinate
	ldr		r2, [PlayerPosition, #4]        // y - coordinate
	ldr 	r3, =0x001F         // blue player
	ldr		r4, [PlayerDimension]
	push	{r4}                // send r4 as 5th argument

	bl 		DrawSquare

    .unreq      PlayerPosition
    .unreq      PlayerDimension

//Obstacles
    ObstacleHealth      .req    r7
    ObstacleList        .req    r8
    SpecificObstacle    .req    r9
    ObstacleWidth       .req    r10

    ldr     ObstacleWidth,    =ObstacleDim
    ldr     r4,     [ObstacleWidth] 
    ldr     ObstacleList, =ObstacleArray
    mov     counter, #0            

//Obstacles
obstacleCreate:
    cmp     counter, #3
    beq     drawTopEdgeBefore
    ldr     SpecificObstacle, [ObstacleList, counter, LSL #2]

    ldr     ObstacleHealth, [SpecificObstacle, #8]    
    cmp     ObstacleHealth, #0
    addeq   counter, #1
    beq     obstacleCreate

    ldr     r1, [SpecificObstacle]
    ldr     r2, [SpecificObstacle, #4]
    ldr     r5, [SpecificObstacle, #8]

    ldr     r3, =0xF81F         // pink colour

    push    {r4, r5}


    bl      DrawRectangle
    add     counter, #1    

    cmp     counter, #3        // making 3 obstacles
    bne     obstacleCreate

//Drawing Game Border
drawTopEdgeBefore:
    mov     r1, #0              //start drawing from this X cord
    mov     r2, #0              //start drawing from this Y cord
    ldr     r3, =0xAFE5         //yellow-green colored pixels

drawTopEdge:
    bl      DrawPixel16bpp
    add     r1, #1
    cmp     r1, #1000           // 1000 pixels
    bne     drawTopEdge
    
    mov     r1, #0              //start drawing from this X cord
    mov     r2, #0              //start drawing from this Y cord
    ldr     r4, =750            //draw edge until this Y cord

drawLeftEdge:
    bl      DrawPixel16bpp
    add     r2, #1
    cmp     r2, r4              // 750 pixels
    bne     drawLeftEdge

drawBottomEdge:
    bl      DrawPixel16bpp
    add     r1, #1
    cmp     r1, #1000           // 1000 pixels
    bne     drawBottomEdge

drawRightEdge:
    bl      DrawPixel16bpp
    sub     r2, #1
    cmp     r2, #0              // 750 pixels   
    bne     drawRightEdge

    mov     r1, #0              //start drawing from this X cord
    mov     r2, #25             //start drawing from this Y cord

drawHeaderInfoBox:
    bl      DrawPixel16bpp
    add     r1, #1
    cmp     r1, #1000
    bne     drawHeaderInfoBox

drawScoreText:
    ldr     r3, =0xFD20         //Orange
    mov     r1, #0              //X cord to write at
    mov     r2, #5              //Y cord to write at
    mov     r5, #0              //char position counter
    ldr     r6, =scoreText      //address of string to write
    b       nextCharLoop

drawScoreNum:
    ldr     r3, =0xFFFFFF       //White
    mov     r1, #60             //X cord to write at
    mov     r5, #0              //char position counter
    ldr     r6, =Score          //address of string to write
    b       nextCharLoop

drawGameName:
    ldr     r3, =0xF81F         //Pink
    ldr     r1, =430            //X cord to write at
    mov     r5, #0              //char position counter
    ldr     r6, =gameName       //address of string to write
    b       nextCharLoop

drawCreatorNames:
    ldr     r3, =0x07E0         //Green
    ldr     r1, =720            //X cord to write at
    mov     r5, #0              //char position counter
    ldr     r6, =creatorNames   //address of string to write
    b       nextCharLoop

nextCharLoop:
    ldrb     r4, [r6, r5]
    
    cmp r4, #'$'                //keep looping until we have drawn out creator names (and thus finished writing)
	beq end    

    cmp     r4, #'@'
    beq     drawScoreNum     

    cmp     r4, #'!'
    beq     drawGameName    

    cmp     r4, #'%'
    beq     drawCreatorNames
	
    add r5, #1                  //increment position counter
	bl DrawChar
	add r1, #10                 //add 10 (spacing between chars)
    b   nextCharLoop   

end:
    pop     {r4-r10, lr}
    bx      lr

.section    .data
.align  4
scoreText:      .asciz  "SCORE:@"
gameName:       .asciz  "iAgree: The Game%"
creatorNames:   .asciz  "A. Seify, N. Maan, O. Brylov$"

