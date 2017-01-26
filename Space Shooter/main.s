// Game by: Arta Seify, Nizar Maan, Alex Brylov

.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    mov     sp, #0x8000
	
	bl		EnableJTAG
    bl      initController
	bl		InitFrameBuffer

	// branch to the halt loop if there was an error initializing the framebuffer
	cmp		r0, #0
	beq		haltLoop$

	bl      GameFlow


haltLoop$:
	b		haltLoop$


.section .data


