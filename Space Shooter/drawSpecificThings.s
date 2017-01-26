.section .text

.global ClearScreen, ClearPauseMenu, DrawPlayer, ClearPlayer, DrawPlayerBullet, ClearPlayerBullet, DrawAIBullet, ClearAIBullet, ClearPawn, ClearKnight, ClearQueen, ClearObstacle, DrawObstacle, DrawPawn, DrawKnight, DrawQueen


//frameBuffer = r0, x-cord = r1, y-cord = r2, colour = r3 Xdimension = r4 Ydimension = r5
// Clears the screen
// r0 = frameBuffer
ClearScreen:
    push    {r4-r10, lr}
    mov     r1, #0
    mov     r2, #0
    mov     r3, #0
    ldr     r4, =1001
    ldr     r5, =751
    push    {r4, r5}

    bl      DrawRectangle

    pop     {r4-r10, lr}
    bx      lr


//r0 = FrameBuffer
ClearPauseMenu:
    push    {r4-r10, lr}

    mov     r1, #400
    mov     r2, #250
    mov     r3, #0
    ldr     r4, =251
    ldr     r5, =281
    push    {r4, r5}

    bl      DrawRectangle

    pop     {r4-r10, lr}
    bx      lr

//r0 = FrameBuffer
DrawPlayer:
    push    {r4-r10, lr}

    PlayerPosition   .req    r9
    PlayerDimension  .req    r10

    ldr     PlayerPosition, =PlayerPos
    ldr     PlayerDimension, =PlayerDim

	ldr		r1, [PlayerPosition]			// x-coordinate
	ldr		r2, [PlayerPosition, #4]        // y - coordinate
	ldr 	r3, =0x001F                     // blue player
	ldr		r4, [PlayerDimension]
	push	{r4}                            // send r4 as 5th argument

	bl 		DrawSquare

    .unreq      PlayerPosition
    .unreq      PlayerDimension


    pop     {r4-r10, lr}
    bx      lr


// makes a black square where the box is
//r0 = FrameBuffer
ClearPlayer:
    push    {r4-r10, lr}


    ldr     r8, =PlayerPos          // getting position of player
    ldr     r1, [r8]                // x-cord
    ldr     r2, [r8, #4]            // y-cord
    mov     r3, #0                  // black colour
    ldr     r8, =PlayerDim          // getting the dimension of player
    ldr     r4, [r8]
    push    {r4}

    bl      DrawSquare

    pop     {r4-r10, lr}
    bx      lr


// draws the bullet
// r0 = FrameBuffer
DrawPlayerBullet:
    push    {r4-r10, lr}


    BulletPosition  .req   r8
    BulletDimension .req   r9

    ldr     BulletPosition, =BulletPos
    ldr     BulletDimension, =BulletDim


	ldr		r1, [BulletPosition]			// x-coordinate
	ldr		r2, [BulletPosition, #4]        // y - coordinate
	ldr 	r3, =0xFFFF                   // white bullet
	ldr		r4, [BulletDimension]
    ldr     r5, [BulletDimension, #4]
	push	{r4, r5}                            // send r4 and r5 as arguments

	bl 		DrawRectangle

    .unreq      BulletPosition
    .unreq      BulletDimension

    pop     {r4-r10, lr}
    bx      lr

// clears the bullet
// r0 = FrameBuffer
ClearPlayerBullet:
    push    {r4-r10, lr}

    BulletPosition  .req    r8
    BulletDimension .req    r9
  

    ldr     BulletPosition, =BulletPos
    ldr     BulletDimension, =BulletDim

    ldr     r1, [BulletPosition]
    ldr     r2, [BulletPosition, #4]
    ldr     r3, =0
    ldr     r4, [BulletDimension]
    ldr     r5, [BulletDimension, #4]
    push    {r4, r5}

    bl      DrawRectangle

    .unreq      BulletPosition
    .unreq      BulletDimension

    pop     {r4-r10, lr}
    bx      lr


// draw computer bullet
// r0 = FrameBuffer, r1 = Unit
DrawAIBullet:
    push    {r4-r10, lr}

    SpecificUnit        .req        r1
    BulletDimension     .req        r8 
     
    ldr     BulletDimension, =BulletDim

    ldr     r2, [SpecificUnit, #16]         // y-coordinate of bullet
    ldr     r3, =0xFFFF                     // white bullet
    ldr     r4, [BulletDimension]           // width of bullet
    ldr     r5, [BulletDimension, #4]       // length of bullet
    ldr     r1, [SpecificUnit, #12]         // x-coordinate of bullet
    push    {r4, r5}

    bl      DrawRectangle

    .unreq      BulletDimension
    .unreq      SpecificUnit


    pop     {r4-r10, lr}
    bx      lr


// clear computer bullet
// r0 = FrameBuffer, r1 = Unit
ClearAIBullet:
    push    {r4-r10, lr}

    SpecificUnit        .req        r1
    BulletDimension     .req        r8      

    ldr     BulletDimension, =BulletDim      

    ldr     r2, [SpecificUnit, #16]         // y-coordinate of bullet
    ldr     r3, =0                          // black rectangle
    ldr     r4, [BulletDimension]           // width of bullet
    ldr     r5, [BulletDimension, #4]       // length of bullet
    ldr     r1, [SpecificUnit, #12]         // x-coordinate of bullet
    push    {r4, r5}

    bl      DrawRectangle

    .unreq      BulletDimension
    .unreq      SpecificUnit


    pop     {r4-r10, lr}
    bx      lr

// draw a pawn
// r0 = FrameBuffer, r1 = The position of the pawn in the array
DrawPawn:
    push    {r4-r12, lr}

    XCor                 .req    r1
    YCor                 .req    r2
    Color                .req    r3
    Dimension            .req    r4
    PawnList             .req    r9
    SpecificPawn         .req    r10

    ldr     PawnList, =PawnArray
    ldr     SpecificPawn, [PawnList, r1, LSL #2]

    ldr		XCor, [SpecificPawn]                  // x-coordinate
	ldr		YCor, [SpecificPawn, #4]              // y-coordinate
	ldr 	Color, =0xF800                        // colour
    ldr     r5, =PawnDim
    ldr     Dimension, [r5]
    push    {Dimension}                           // dimension

	bl   	DrawSquare                            //draws square


    .unreq      XCor
    .unreq      YCor
    .unreq      Color
    .unreq      Dimension
    .unreq      PawnList
    .unreq      SpecificPawn


    pop     {r4-r12, lr}
    bx      lr

// clear a pawn
// r0 = FrameBuffer, r1 = The position of the pawn in the array
ClearPawn:
    push    {r4-r12, lr}

    XCor                 .req    r1
    YCor                 .req    r2
    Color                .req    r3
    Dimension            .req    r4
    PawnList             .req    r9
    SpecificPawn         .req    r10

    ldr     PawnList, =PawnArray
    ldr     SpecificPawn, [PawnList, r1, LSL #2]

    ldr		XCor, [SpecificPawn]                  // x-coordinate
	ldr		YCor, [SpecificPawn, #4]              // y-coordinate
	ldr 	Color, =0x0                           // colour
    ldr     r5, =PawnDim
    ldr     Dimension, [r5]
    push    {Dimension}                           // dimension

	bl   	DrawSquare                            //draws square


    .unreq      XCor
    .unreq      YCor
    .unreq      Color
    .unreq      Dimension
    .unreq      PawnList
    .unreq      SpecificPawn


    pop     {r4-r12, lr}
    bx      lr

// draw a knight
// r0 = FrameBuffer, r1 = The position of the pawn in the array
DrawKnight:
    push    {r4-r10, lr}

    XCor                 .req    r1
    YCor                 .req    r2
    Color                .req    r3
    Dimension            .req    r4
    KnightList           .req    r9
    SpecificKnight       .req    r10

    ldr     KnightList, =KnightArray
    ldr     SpecificKnight, [KnightList, r1, LSL #2]

    ldr		XCor, [SpecificKnight]                 // x-coordinate
	ldr		YCor, [SpecificKnight, #4]             // y-coordinate
	ldr 	Color, =0xFFFF                         // colour
    ldr     r5, =KnightDim
    ldr     Dimension, [r5]
    push    {Dimension}                           // dimension

	bl   	DrawSquare                            //draws square


    .unreq      XCor
    .unreq      YCor
    .unreq      Color
    .unreq      Dimension
    .unreq      KnightList
    .unreq      SpecificKnight

    pop     {r4-r10, lr}
    bx      lr


// clear a knight
// r0 = FrameBuffer, r1 = The position of the pawn in the array
ClearKnight:
    push    {r4-r10, lr}

    XCor                 .req    r1
    YCor                 .req    r2
    Color                .req    r3
    Dimension            .req    r4
    KnightList           .req    r9
    SpecificKnight       .req    r10

    ldr     KnightList, =KnightArray
    ldr     SpecificKnight, [KnightList, r1, LSL #2]

    ldr		XCor, [SpecificKnight]                 // x-coordinate
	ldr		YCor, [SpecificKnight, #4]             // y-coordinate
	ldr 	Color, =0                              // colour
    ldr     r5, =KnightDim
    ldr     Dimension, [r5]
    push    {Dimension}                           // dimension

	bl   	DrawSquare                            //draws square


    .unreq      XCor
    .unreq      YCor
    .unreq      Color
    .unreq      Dimension
    .unreq      KnightList
    .unreq      SpecificKnight

    pop     {r4-r10, lr}
    bx      lr




// draw a queen
// r0 = FrameBuffer, r1 = The position of the pawn in the array
DrawQueen:
    push    {r4-r10, lr}

    XCor                .req    r1
    YCor                .req    r2
    Color               .req    r3
    Dimension           .req    r4
    QueenList           .req    r9
    SpecificQueen       .req    r10


    ldr     QueenList, =QueenArray
    ldr     SpecificQueen, [QueenList, r1, LSL #2]

    ldr		XCor, [SpecificQueen]                 // x-coordinate
	ldr		YCor, [SpecificQueen, #4]             // y-coordinate
	ldr 	Color, =0x780F                        // colour
    ldr     r5, =QueenDim
    ldr     Dimension, [r5]
    push    {Dimension}                           // dimension

	bl   	DrawSquare                            //draws square


    .unreq      XCor
    .unreq      YCor
    .unreq      Color
    .unreq      Dimension
    .unreq      QueenList
    .unreq      SpecificQueen

    pop     {r4-r10, lr}
    bx      lr

// clear a queen
// r0 = FrameBuffer, r1 = The position of the pawn in the array
ClearQueen:
    push    {r4-r10, lr}

    XCor                .req    r1
    YCor                .req    r2
    Color               .req    r3
    Dimension           .req    r4
    QueenList           .req    r9
    SpecificQueen       .req    r10


    ldr     QueenList, =QueenArray
    ldr     SpecificQueen, [QueenList, r1, LSL #2]

    ldr		XCor, [SpecificQueen]                 // x-coordinate
	ldr		YCor, [SpecificQueen, #4]             // y-coordinate
	ldr 	Color, =0                             // colour
    ldr     r5, =QueenDim
    ldr     Dimension, [r5]
    push    {Dimension}                           // dimension

	bl   	DrawSquare                            //draws square


    .unreq      XCor
    .unreq      YCor
    .unreq      Color
    .unreq      Dimension
    .unreq      QueenList
    .unreq      SpecificQueen

    pop     {r4-r10, lr}
    bx      lr


// clear an obstacle
// r0 = FrameBuffer, r1 = the obstacle
ClearObstacle:
    push    {r4-r10, lr}

    SpecificObstacle    .req        r1

    ldr     r2, [SpecificObstacle, #4]
    ldr     r6, =ObstacleDim
    ldr     r4, [r6]
    ldr     r5, [SpecificObstacle, #8]
    ldr     r3, =0                  // black
    ldr     r1, [SpecificObstacle]

    push    {r4, r5}

    bl      DrawRectangle

    .unreq      SpecificObstacle

    pop     {r4-r10, lr}
    bx      lr


// draw an obstacle
// r0 = Framebuffer, r1 = the obstacle
DrawObstacle:
    push    {r4-r10, lr}

    SpecificObstacle    .req        r1

    ldr     r2, [SpecificObstacle, #4]
    ldr     r6, =ObstacleDim
    ldr     r4, [r6]
    ldr     r5, [SpecificObstacle, #8]
    ldr     r3, =0xF81F         // pink colour
    ldr     r1, [SpecificObstacle]

    push    {r4, r5}

    bl      DrawRectangle

    .unreq      SpecificObstacle

    pop     {r4-r10, lr}
    bx      lr
