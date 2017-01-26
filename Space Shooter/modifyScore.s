//This file handles score updating
.section    .text
.globl  ModifyScore

/* 
r0 = FrameBuffer
r1 = Score Modify
    0 = Decrease 
    1 = Increase
r2 = Type of unit killed:
    0 = Queen
    1 = Knight
    2 = Pawn
*/
ModifyScore:
    push    {r4-r10, lr}

    scoreAddress        .req    r6
    scoreHundredsPlace  .req    r7
    scoreTensPlace      .req    r8
    scoreOnesPlace      .req    r9
    charCounter         .req    r10

    mov     charCounter,    #0
    ldr     scoreAddress,   =Score
    ldrb    scoreHundredsPlace, [scoreAddress]
    ldrb    scoreTensPlace, [scoreAddress, #1]
    ldrb    scoreOnesPlace, [scoreAddress, #2]
    
    //use some register value to know whether to increment or decrement score
    cmp   r1, #1     
    beq   increaseScore
    b     decreaseScore

//NOTE: Score caps at 999
//NOTE: MAXIMUM possible score is 350 (if we start the score from 0)
increaseScore:
    //now we need to check a register to determine which unit was killed and add appropriate points
    //100 pts for Queen = 0
    //10 pts for Knight = 1
    //5 points for Pawn = 2


    cmp r2, #0
    beq add100pts
    
    cmp r2, #1
    beq add10pts
    
    cmp r2, #2
    beq add5pts
 
add100pts:
    cmp scoreHundredsPlace, #'8'
    moveq   r1, #'9'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'7'
    moveq   r1, #'8'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'6'
    moveq   r1, #'7'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'5'
    moveq   r1, #'6'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'4'
    moveq   r1, #'5'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'3'
    moveq   r1, #'4'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'2'
    moveq   r1, #'3'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'1'
    moveq   r1, #'2'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'0'
    moveq   r1, #'1'
    streqb  r1,    [scoreAddress]
 
    b   clearOldScore

add10pts:
    cmp scoreTensPlace, #'9'
    moveq   r1, #'0'
    streqb  r1,    [scoreAddress, #1]
    beq add100pts                       //increase hundreds by 1 since tens place was a 9

    cmp scoreTensPlace, #'8';
    moveq   r1, #'9'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'7';
    moveq   r1, #'8'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'6';
    moveq   r1, #'7'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'5';
    moveq   r1, #'6'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'4';
    moveq   r1, #'5'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'3';
    moveq   r1, #'4'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'2';
    moveq   r1, #'3'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'1';
    moveq   r1, #'2'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'0';
    moveq   r1, #'1'
    streqb  r1,    [scoreAddress, #1]

    b   clearOldScore

add5pts:
    cmp scoreOnesPlace, #'0'
    moveq   r1, #'5'
    streqb  r1, [scoreAddress, #2]
    
    cmp scoreOnesPlace, #'5'
    moveq   r1, #'0'
    streqb  r1, [scoreAddress, #2]
    beq add10pts

    b   clearOldScore



decreaseScore:
//check if the hundreds place is a 0
checkIfZeroHundreds:               
    cmp scoreHundredsPlace, #'0'   
    beq checkIfZeroTens
    b   nonZeroHundreds 

//check if the tens place is a 0
checkIfZeroTens:
    cmp scoreTensPlace, #'0'        
    beq zeroScore
    b   reduceTens

//score becomes 0 since hundreds and tens place are 0
zeroScore:
    mov     r1,     #'0'
    strb    r1,    [scoreAddress]
    strb    r1,    [scoreAddress, #1]
    strb    r1,    [scoreAddress, #2]
    b   clearOldScore

//reduce the tens place
reduceTens:
    cmp scoreTensPlace, #'1'
    moveq   r1, #'0'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'2';
    moveq   r1, #'1'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'3';
    moveq   r1, #'2'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'4';
    moveq   r1, #'3'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'5';
    moveq   r1, #'4'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'6';
    moveq   r1, #'5'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'7';
    moveq   r1, #'6'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'8';
    moveq   r1, #'7'
    streqb  r1,    [scoreAddress, #1]

    cmp scoreTensPlace, #'9';
    moveq   r1, #'8'
    streqb  r1,    [scoreAddress, #1]

    b clearOldScore
           
/*when the hundreds is non-zero check if the tens place is 0 to know whether
  the hundreds place should also be reduced*/

nonZeroHundreds:
    cmp scoreTensPlace, #'0'
    beq reduceHundreds
    b   reduceTens          //if the tens is not 0, then only reduce the tens

//reduce the hundreds since the tens place was 0
reduceHundreds:    
    cmp scoreHundredsPlace, #'1'
    moveq   r1, #'0'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'2'
    moveq   r1, #'1'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'3'
    moveq   r1, #'2'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'4'
    moveq   r1, #'3'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'5'
    moveq   r1, #'4'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'6'
    moveq   r1, #'5'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'7'
    moveq   r1, #'6'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'8'
    moveq   r1, #'7'
    streqb  r1,    [scoreAddress]

    cmp scoreHundredsPlace, #'9'
    moveq   r1, #'8'
    streqb  r1,    [scoreAddress]

    mov     r1, #'9'
    strb    r1,    [scoreAddress, #1]      //write 9 onto tens place

    b clearOldScore             //test it out without drawing the black box first            

clearOldScore:
    mov     r1, #60             //X cord to write at
    mov     r2, #1              //Y cord to write at
    ldr r3, =0x0                //black
    mov r4, #40
    mov r5, #20
    push    {r4-r5}
    bl  DrawRectangle
    mov r1, #60
    mov r2, #5

reWriteScore:
    ldr r3, =0xFFFFF           //White text  
    ldrb     r4, [scoreAddress, charCounter]   

    cmp     r4, #'!'
    beq     end    

    add charCounter, #1         //increment position counter
    push {r1-r3}
	bl DrawChar
    pop {r1-r3}
	add r1, #10                 //add 10 (spacing between chars)
    b   reWriteScore
    
end:
    .unreq  scoreAddress        
    .unreq  scoreHundredsPlace  
    .unreq  scoreTensPlace      
    .unreq  scoreOnesPlace      
    .unreq  charCounter         
    pop {r4-r10, lr}
    bx lr
     

    
    
    
