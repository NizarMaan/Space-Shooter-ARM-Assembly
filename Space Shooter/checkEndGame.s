.section    .text
.globl  CheckEndGame

// checks to see if the game is over, and who the victor is if the game is over
CheckEndGame:
    push    {r4-r10, lr}

//check if all enemys' health are 0
checkEnemies:
    counter             .req    r10
    gameStateAddress    .req    r6
    gameState           .req    r5

    ldr gameStateAddress, =GameState
 
    mov         counter,    #0

    //Queens
    QueenHealth     .req    r7
    QueenList       .req    r8
    SpecificQueen   .req    r9
  
    ldr     QueenList, =QueenArray
checkQueenHealth:
    ldr     SpecificQueen, [QueenList]
    ldr     QueenHealth,   [SpecificQueen, #20]     //this Queen's health

    cmp     QueenHealth,    #0
    bne     checkScore

    add     counter,    #1
    add     QueenList,  #4 
    cmp     counter,    #2
    bne     checkQueenHealth

    .unreq      QueenHealth
    .unreq      QueenList
    .unreq      SpecificQueen   
    
    //Knights    
    mov counter,    #0
    KnightHealth     .req    r7
    KnightList       .req    r8
    SpecificKnight   .req    r9
  
    ldr     KnightList, =KnightArray

checkKnightHealth:
    ldr     SpecificKnight, [KnightList]
    ldr     KnightHealth,   [SpecificKnight, #20]     //this Knight's health

    cmp     KnightHealth,    #0
    bne     checkScore

    add     counter,    #1
    add     KnightList, #4 
    cmp     counter,    #5
    bne     checkKnightHealth

    .unreq      KnightHealth
    .unreq      KnightList
    .unreq      SpecificKnight

    //Pawn    
    mov counter,    #0
    PawnHealth     .req    r7
    PawnList       .req    r8
    SpecificPawn   .req    r9
  
    ldr     PawnList, =PawnArray

checkPawnHealth:
    ldr     SpecificPawn, [PawnList]
    ldr     PawnHealth,   [SpecificPawn, #20]     //this Pawn's health

    cmp     PawnHealth,    #0
    bne     checkScore

    add     counter,    #1
    add     PawnList, #4 
    cmp     counter,    #10
    bne     checkPawnHealth

    .unreq      PawnHealth
    .unreq      PawnList
    .unreq      SpecificPawn
    .unreq      counter 
    
    // game won
    mov r9,    #1
    mov gameState,  #3
    strb    gameState, [gameStateAddress]
    mov r1, r9
    bl  EndGameScreen
    b   end
          
checkScore:
    scoreAddress        .req    r4
    scoreHundredsPlace  .req    r9
    scoreTensPlace      .req    r8
    scoreOnesPlace      .req    r7
    
    ldr scoreAddress,    =Score

    ldrb    scoreHundredsPlace, [scoreAddress]
    cmp scoreHundredsPlace, #'0'
    bne end   

    ldrb    scoreTensPlace, [scoreAddress, #1]
    cmp scoreTensPlace, #'0'
    bne end

    ldrb    scoreOnesPlace, [scoreAddress, #2]
    cmp scoreOnesPlace, #'0'
    bne end

    // game lost
    mov r9,    #0
    mov gameState,  #3
    strb    gameState, [gameStateAddress]
    mov r1, r9
    bl  EndGameScreen
        
end:    
    pop {r4-r10, lr}
    bx  lr
