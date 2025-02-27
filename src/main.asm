INCLUDE "./src/common/macros.asm"
INCLUDE "./src/common/ioregs.asm"

SECTION "HEADER", ROM0[$0100]
entryPoint:
	di
	jp init

ds $150-@ ;reserve space for logo, etc

SECTION "INIT", ROM0
init::
	ld sp, 0xD000
	ld hl, oam_routine
	ld de, 0xFF80
	getsize oam_routine, c
	.memcpy:
		ldi a, [hl]
		ld [de], a
		inc de
		dec c
	jr nz, .memcpy
	
end:
	halt
	jr end

SECTION "OAM DMA", ROM0
oam_routine:
	ld [IO_OAM_DMA], a
	ld a, 0x28
	.stall:
		dec a
		jr nz, .stall
	ret
	.end