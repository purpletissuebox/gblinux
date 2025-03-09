INCLUDE "hwregs.inc"
INCLUDE "macros.inc"
INCLUDE "common/vblank.inc"

SECTION "INIT", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;starts the game
;puts all hardware registers into a known state
;loads minimal text graphics into tile memory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init::
	;init stack pointer for function calls
	di
	ld sp, 0xD000
	
	;init oam function
	ld de, oam_function
	ld hl, oamRoutine
	ldsize c, oam_function
	rst memcpy
	
	;init window and bkg positions
	ld a, BANK(shadow_scroll_y)
	ldh [IO_WRAM_BANK], a
	xor a
	ld hl, shadow_scroll_y
	ldi [hl], a
	ldi [hl], a
	ld a, 0xA7
	ldi [hl], a
	ldi [hl], a

	;init gfxtask queue
	ld a, LOW(gfx_task_queue)
	ld hl, gfx_task_tail
	ldi [hl], a
	ldi [hl], a
	
	;clear sprites
	xor a
	ld hl, shadow_oam
	ldsize c, shadow_oam
	rst memset ;init oam

	;clear colors
	xor a
	ld hl, shadow_palettes_bkg
	ld c, shadow_palettes_obj.end - shadow_palettes_bkg
	rst memset
	
	;zero io ports
	xor a
	ldh [IO_SERIAL_CTRL], a
	ldh [IO_TIMER_CTRL], a
	ldh [IO_INTERRUPT_REQUEST], a
	ldh [IO_SOUND_MAIN_CTRL], a
	ldh [IO_SCROLL_Y], A
	ldh [IO_SCROLL_X], a
	ldh [IO_LCD_Y_COMPARE], a
	ldh [IO_DMG_BKG_PALETTE], a
	ldh [IO_DMG_OBJ_PALETTE1], a
	ldh [IO_DMG_OBJ_PALETTE2], a
	ldh [IO_WINDOW_Y], a
	ld a, 0x07
	ldh [IO_WINDOW_X], a
	
	;init lcd
	ld a, LCD_ENABLE | WIN_MAP_SELECT | WIN_ENABLE | SPRITE_ENABLE | SPRITE_PRIORITY
	ldh [IO_LCD_CTRL], a
	ld a, STAT_IRQ_LYC
	ldh [IO_LCD_STATUS], a
	
	;swap banks and enable vblank interrupt
	ld a, 0x01
	ldh [ram_bank], a
	ldh [IO_WRAM_BANK], a
	ldh [vram_bank], a
	ldh [IO_VRAM_BANK], a
	ldh [rom_bank], a
	ld  [MBC_ROM_BANK], a
	ldh [IO_INTERRUPT_ENABLE], a

	;cancel any pending interrupts before starting
	xor a
	ldh [IO_INTERRUPT_REQUEST], a
	ld a, RELOAD_PALETTES | RELOAD_SCROLL
	ldh [redraw_screen], a
	ei
	jp MAIN

SECTION "OAM_DMA_ROUTINE_ROM", ROM0
oam_function:
	LOAD "OAM_DMA_ROUTINE_RAM", HRAM
	oamRoutine::
		ldh [IO_OAM_DMA], a
		ld a, 0x28
			.wait:
			dec a
			jr nz, oamRoutine.wait
		ret
	ENDL
.end:
