INCLUDE "hwregs.inc"
INCLUDE "common/vblank.inc"

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
	rr e
	jr nc, VBLANK.noGfxTasks
		ld hl, gfx_task_head
		.gfx_loop:
			ld l, [hl]
			ldi a, [hl]
			ldh [IO_DMA_SRC_L], a
			and 0x07
			ldh [IO_WRAM_BANK], a
			ldi a, [hl]
			ldh [IO_DMA_SRC_H], a
			ldi a, [hl]
			ld [MBC_ROM_BANK], a
			ldi a, [hl]
			ldh [IO_DMA_DST_L], a
			and 0x01
			ldh [IO_VRAM_BANK], a
			ldi a, [hl]
			ldh [IO_DMA_DST_H], a
			ldh a, [IO_LCD_CURRENT_LINE]
			cpl
			add 0x9A
			swap a
			rrca
			ld d, a
			ldi a, [hl]
			cp d
				jr nc, .pauseGfxTasks
			ldh [IO_DMA_TRIGGER], a
			ld a, l
			ld l, LOW(gfx_task_head)
			cp LOW(gfx_task_queue + 2 + 6*10)
			jr c, .savePtr
				ld a, LOW(gfx_task_tail)
			.savePtr:
			ldd [hl], a
			cp [hl]
			inc hl
		jr nz, .gfx_loop
		jr .noGfxTasks
		.pauseGfxTasks:
		ld a, RELOAD_GFX_TASK
		ldh [redraw_screen], a
	.noGfxTasks:
	pop af
	ldh [IO_WRAM_BANK], a
	
	pop hl
	pop de
	pop bc
	pop af
	reti
