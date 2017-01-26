.section    .text

.globl  EndGameScreen

// r0 = FrameBuffer, r1 = Who won. 0 = lose, 1 = win
EndGameScreen:
    push    {r4-r12, lr}
    

  	GameOver    .req    r10                    //0 lose, 1 win 
    menuColor   .req    r3  


    mov     GameOver, r1

        bl  ClearScreen
 

    cmp GameOver, #1 // win 
    ldreq menuColor,  =0x001F   //blue
    ldrne menuColor,  =0x7800   //red
    
    
    ldr r1, =400                //start drawing from this X cord    
    ldr r2, =335                //start drawing from this Y cord

    mov r4, #200                //width
    mov r5, #140                //height
    
    push    {r4, r5}
    
    bl  DrawRectangle
    .unreq  menuColor
 
    ldr r1, =400                //start drawing from this X cord     
    ldr r2, =335                //start drawing from this Y cord

    ldr r4, =475                //draw until this Y cord is reached
    ldr r5, =600                //draw row until this X cord   (525) 

    outlnCol    .req   r3
    ldr outlnCol,   =0xFFFFFF   //white                             

drawTopEdge:
    bl  DrawPixel16bpp
    add r1, #1
    cmp r5, r1                  //check if we've reached end of row
    bne drawTopEdge             //draw first (top) row of the outline

drawLeftEdge:
    ldr r1, =400                //move back to LEFT edge of box to draw the side outlines of menu box    
    add r2, #1                  //move down a row
    bl  DrawPixel16bpp      

drawRightEdge:
    ldr r1, =600                //move back to RIGHT edge of box to draw the side outlines of menu box    
    bl  DrawPixel16bpp   
    cmp r2, r4
    bne drawLeftEdge
    ldr r1, =400
    
drawBottomEdge:    
    bl  DrawPixel16bpp 
    add r1, #1
    cmp r5, r1                  //check if we've reached end of row
    bne drawBottomEdge          //draw first (top) row of the outline

    .unreq  outlnCol

writeMenuOptions:
    textColor   .req   r3       //variable for text's color 
    ldr textColor,  =0xF800     //red text

drawMessage:
	cmp GameOver, #1
    ldrne   textColor,  =0xFFE0 //use yellow
    ldreq textColor,  =0xFFFFFF //otherwise use white text

    ldr r1, =460                //x cord to start drawing
    ldr r2, =400                //y cord to start drawing
	mov r5, #0                  //position counter for char in string to draw
	
	cmp GameOver, #1
	ldreq r6, =winMSG      //address of the String to write
	ldrne r6, =loseMSG

nextCharLoop:	
	ldrb r4, [r6,r5]            //load first char into r4

    cmp r4, #'$'                //keep looping until we have drawn out creator names (and thus finished drawing)
	beq end

	add r5, #1                  //increment position counter
	bl DrawChar
	add r1, #10                 //add 10 (spacing between chars)
    b   nextCharLoop                   


end:
    .unreq  GameOver
    .unreq  textColor
    pop     {r4-r12, lr}
    bx      lr


.section    .data
.align  4

winMSG:     .asciz "YOU WIN!$"
loseMSG:    .asciz  "YOU LOSE!$"
