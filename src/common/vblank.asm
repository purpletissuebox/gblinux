INCLUDE "hwregs.inc"
INCLUDE "common/vblank.inc"

DEF COLORS_PER_LOOP EQU 2

SECTION "VBLANK_HANDLER", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;VBLANK interrupt handler
;uses bitfield (see vblank.inc) to determine what graphics to process this frame.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VBLANK::
	;save register and ram bank context
	push bc
	push de
	push hl
	ldh a, [ram_bank]
	push af
	ld a, BANK("GFX_VARS")
	ldh [IO_WRAM_BANK], a
	
	;get graphics flags and reset them to zero for next frame
	ldh a, [redraw_screen]
	ld e, a
	xor a
	ldh [redraw_screen], a
	
	;if e & 1, do sprites
	rr e
	call c, oamRoutine
	
	;if e & 2, do scroll registers
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
	
	;if e & 4, do graphics tasks
	rr e
	jr nc, VBLANK.noGfxTasks
		ld hl, gfx_task_tail
		ld l, [hl] ;hl points to first incomplete task
		.gfx_loop:
			ldi a, [hl] ;get dma source lo and wram bank
			ldh [IO_DMA_SRC_L], a ;dma hardware ignores the last 4 bits
			and 0x07
			ldh [IO_WRAM_BANK], a
			ldi a, [hl] ;get dma source hi
			ldh [IO_DMA_SRC_H], a
			ldi a, [hl] ;get rom bank
			ld [MBC_ROM_BANK], a
			ldi a, [hl] ;get dma destination lo and vram bank
			ldh [IO_DMA_DST_L], a ;again, hardware ignores low order bits here
			and 0x01
			ldh [IO_VRAM_BANK], a
			ldi a, [hl] ;get dma destination hi
			ldh [IO_DMA_DST_H], a
			
			ldh a, [IO_LCD_CURRENT_LINE]
			cpl
			add 0x9A ;calculate remaining lines in vblank
			ld d, a
			add a
			add d
			add a
			add a ;multiply by 12, i estimate you can copy 14 tiles per line so this is on the safe side
			ld d, a
			ldi a, [hl] ;get number of desired tiles
			cp d
				jr nc, .pauseGfxTasks ;if we cant copy that many this frame, bail out now
			ldh [IO_DMA_TRIGGER], a ;perform the copy
			
			ld a, l
			add 0x02
			xor l
			and 0x3F
			xor l ;bit trick, A now points to the next task, wrapping around
			ld l, LOW(gfx_task_tail)
			ldi [hl], a ;mark this task as complete, hl points to the end of the queue
			cp [hl] ;if the next free slot is the same as the end of the queue, then the queue is empty
			ld l, a ;hl points to next task
		jr nz, .gfx_loop ;repeat for each task in the queue
			jr .noGfxTasks
		.pauseGfxTasks:
		ld a, RELOAD_GFX_TASK ;get here when more tasks are requested but vblank is about to end
		ldh [redraw_screen], a ;request more task processing next frame
	.noGfxTasks:
	
	;if e & 8, do palettes
	ei
	rr e
	jr nc, VBLANK.noPalettes
		ld hl, shadow_palettes_bkg ;hl points to color data
		ld c, LOW(IO_CRAM_BKG_SELECT) ;c points to I/O port of interest
		.loadColors:
			ld b, 0x20/COLORS_PER_LOOP ;8 palettes * 4 colors
			ld a, CRAM_INCREMENT
			ldh [c], a ;select palette #0 and autoincrement
			inc c ;point at color input port
			.copy:
				rst waitVRAM
				REPT COLORS_PER_LOOP*2
					ldi a, [hl]
					ldh [c], a ;copy color data
				ENDR
				dec b
			jr nz, VBLANK.copy
			
			inc c ;if we were pointing at bkg data before, now it's obj data
			bit 1, c ;if we were pointing at obj data before, now it's FF6C
		jr nz, VBLANK.loadColors
	.noPalettes:
	
	;restore context
	pop af
	ldh [IO_WRAM_BANK], a
	pop hl
	pop de
	pop bc
	pop af
	ret
