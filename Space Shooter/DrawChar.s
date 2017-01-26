
//function for drawing a char will go here, pass in arguments for font-color and coordinates from DrawStartMenu
/*  r1 = x cord
    r2 = y cord
    r3 = color
    r4 = char 

    Code modified from tutorial ex09*/  
  
.section    .text
.globl   DrawChar

DrawChar:
    push    {r5-r10, lr}            //store these registers on system stack just in case

    chAdr   .req    r5       
    px      .req    r6
    py      .req    r7
    row		.req	r8
	mask	.req    r9
    
    ldr chAdr,	=font		        //load the address of the font map
    add chAdr,  r4, lsl #4          //char address = font base + (char * 16)
    
    mov r10,    r1
    mov r11,    r2
    mov py,     r2                  //initialize pixel y cord

charLoop$:        
    mov px,     r10                  //initialize pixel x cord   

    mov mask,   #0x01               //set mask to LSB

    ldrb    row,    [chAdr],    #1  //load the row byte, post increment chAdr

rowLoop$:
    tst		row,	mask		    //test row byte against the bitmask
	beq		noPixel$
    
    mov r1, px      
	mov r2, py      

    bl  DrawPixel16bpp			   

noPixel$:
	add		px,		#1			    //increment x coordinate by 1
	lsl		mask,	#1			    //shift bitmask left by 1

	tst		mask,	#0x100		    //test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py,		#1			    //increment y coordinate by 1

	tst		chAdr,	#0xF
	bne		charLoop$			    //loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask

end:
    mov r1, r10
	mov r2, r11
    pop {r5-r10, pc}

.section    .data
.align  4
font:		    .incbin	"font.bin"
