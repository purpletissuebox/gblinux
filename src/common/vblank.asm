INCLUDE "hwregs.inc"
DEF COLORS_PER_LOOP EQU 2

SECTION "VBLANK_HANDLER", ROM0
VBLANK::
	push bc
	push de
	push hl
	
	ldh a, [ram_bank]
	push af
	ld a, BANK("GFX_VARS")
	ldh [IO_WRAM_BANK], a
	
	ldh a, [redraw_screen]
	ld e, a
	xor a
	ldh [redraw_screen], a
	
	rr e
	call c, oamRoutine
	
	rr e
	jr nc, VBLANK.noScroll
		ld hl, shadow_scroll_y
		ldi a, [hl]
		ldh [IO_SCROLL_Y], a
		ldi a, [hl]
		ldh [IO_SCROLL_X], a
		ldi a, [hl]
		ldh [IO_WINDOW_Y], a
		ldi a, [hl]
		ldh [IO_WINDOW_X], a
	
	.noScroll:
	ei
	rr e
	jr nc, VBLANK.noPalettes
		ld hl, shadow_palettes_bkg
		ld c, LOW(IO_CRAM_BKG_SELECT)
		.loadColors:
			ld b, 0x20/COLORS_PER_LOOP
			ld a, CRAM_INCREMENT
			ldh [c], a
			inc c
			.copy:
				rst waitVRAM
				REPT COLORS_PER_LOOP*2
				ldi a, [hl]
				ldh [c], a
				ENDR
				dec b
			jr nz, VBLANK.copy
			
			inc c
			bit 1, c
		jr nz, VBLANK.loadColors
	
	.noPalettes:
	pop af
	ldh [IO_WRAM_BANK], a
	
	pop hl
	pop de
	pop bc
	pop af
	add sp, 0x0002
	reti