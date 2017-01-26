//Draw the initial game menu

.section    .text
.globl  DrawStartMenu

DrawStartMenu:
    push    {r4-r10, lr}

    outLineColor    .req    r3
    ldr outLineColor,   =0xFFFFFF       //White
    mov r1, #0
    mov r2, #0    

//Draw box outline
drawTopEdge:
    bl  DrawPixel16bpp
    add r1, #1
    cmp r1, #1000
    bne drawTopEdge

drawRightEdge:
    bl  DrawPixel16bpp
    add r2, #1
    ldr r4, =750
    cmp r2, r4
    bne drawRightEdge

drawBottomEdge:
    bl  DrawPixel16bpp
    sub r1, #1
    cmp r1, #0
    bne drawBottomEdge

drawLeftEdge:
    bl  DrawPixel16bpp
    sub r2, #1
    cmp r2, #0
    bne drawLeftEdge
    .unreq  outLineColor

//write text onto screen
    charXcord       .req    r1
    charYcord       .req    r2
    charColor       .req    r3
    charToWrite     .req    r4
    charPosCounter  .req    r5
    stringAddress   .req    r6    
    
writeCreatorNames:
    mov charXcord,  #10
    mov charYcord,  #10
    ldr charColor,  =0x07E0     //Green font
    mov charPosCounter, #0
    ldr stringAddress,  =creatorNames
    b   nextCharLoop
    
writeGameName:
    ldr charXcord,  =400
    ldr charYcord,  =300
    ldr charColor,  =0xF81F    //Magenta font
    mov charPosCounter, #0
    ldr stringAddress,  =gameName
    b   nextCharLoop

writeMenuInstruction:
    ldr charXcord,  =425
    ldr charYcord,  =390
    ldr charColor,  =0xFFE0    //Yellow font
    mov charPosCounter, #0
    ldr stringAddress,  =menuInstruction
    b   nextCharLoop

nextCharLoop:
    ldrb charToWrite,    [stringAddress, charPosCounter]

    cmp charToWrite,    #'$'
    beq end

    cmp charToWrite,    #'#'
    beq writeGameName

    cmp charToWrite,    #'@'
    beq writeMenuInstruction
    
    add charPosCounter,    #1
    bl  DrawChar
    add charXcord,  #15
    b   nextCharLoop

end:
    pop {r4-r10, lr}
    bx  lr

.section    .data
.align  4

creatorNames:   .asciz  "Arta Seify, Nizar Maan, Oleksiy Brylov#"
gameName:       .asciz  "iAgree: The Game@"
menuInstruction:.asciz  "Press 'Start'$"

