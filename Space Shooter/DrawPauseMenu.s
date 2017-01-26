.section .text

.globl  DrawPauseMenu

//draw our start menu somewhat in the middle of the screen

DrawPauseMenu:
    push    {r4-r10, lr}        //save values onto system stack just in case
    mov     r9, r2

    PointerPos  .req   r8    
    ldr     r9, =PauseMenuPointer
    ldrb    PointerPos, [r9]

    menuColor   .req   r3   
    ldr menuColor,  =0x03EF   //cyan (blue-ish color)
    
    ldr r1, =400                //start drawing from this X cord    
    mov r2, #250                //start drawing from this Y cord

    mov r4, #250                //width
    mov r5, #280                //height
    
    push    {r4, r5}
    
    bl  DrawRectangle
    .unreq  menuColor
 
    ldr r1, =400                //start drawing from this X cord     
    mov r2, #250                //start drawing from this Y cord

    ldr r4, =530                //draw until this Y cord is reached
    ldr r5, =650                //draw row until this X cord   (525) 

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
    ldr r1, =650                //move back to RIGHT edge of box to draw the side outlines of menu box    
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

drawMenuName:
    ldr r1, =475                //x cord to start drawing
	mov r2, #300                //y cord to start drawing
	mov r5, #0                  //position counter for char in string to draw
	ldr r6, =menuName           //address of the String to write
    b   nextCharLoop

drawResumeOption:
    cmp PointerPos,    #0
    ldreq   textColor,  =0xFFE0  //use yellow
    ldrne   textColor,  =0xFFFFFF  //otherwise use white text
    ldr r1, =495
    ldr r2, =350
    mov r5, #0
    ldr r6, =resumeOption
    b   nextCharLoop

drawRestartOption:
    cmp PointerPos,    #1
    ldreq   textColor,  =0xFFE0 //use yellow
    ldrne textColor,  =0xFFFFFF //otherwise use white text
    ldr r1, =490                //x cord to start drawing
    ldr r2, =400                //y cord to start drawing
	mov r5, #0                  //position counter for char in string to draw
	ldr r6, =restartOption      //address of the String to write
    b   nextCharLoop

drawQuitOption:
    cmp PointerPos,    #2
    ldreq   textColor,  =0xFFE0 //use yellow
    ldrne textColor,  =0xFFFFFF //otherwise use white text
    ldr r1, =500                //x cord to start drawing	
    ldr r2, =450                //y cord to start drawing
	mov r5, #0                  //position counter for char in string to draw
	ldr r6, =quitOption         //address of the game's name string
    b   nextCharLoop

/*  r1 = x cord
    r2 = y cord
    r3 = color
    r4 = char */ 

nextCharLoop:	
	ldrb r4, [r6,r5]            //load first char of game name into r4

    cmp r4, #'$'                //keep looping until we have drawn out creator names (and thus finished drawing)
	beq end
    
    cmp r4, #'%'                //if reached the end, draw next string
	beq drawResumeOption	
    
    cmp r4, #'^'                //if reached the end, draw next string
	beq drawRestartOption
    
    cmp r4, #'~'                //if reached the end, draw next string
	beq drawQuitOption

	add r5, #1                  //increment position counter
	bl DrawChar
	add r1, #10                 //add 10 (spacing between chars)
    b   nextCharLoop                   

end:
    .unreq  PointerPos
    .unreq  textColor
    pop {r4-r10, pc}

/*                                         | |   
 set up strings for drawing                v v 
 special chars used to signify end of string */

.section    .data

.align  4

menuName:       .asciz  "PAUSE MENU%"
resumeOption:   .asciz  "Resume^"
restartOption:  .asciz  "Restart~"
quitOption:     .asciz  "Quit$"

