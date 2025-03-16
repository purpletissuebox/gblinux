INCLUDE "hwregs.inc"
INCLUDE "macros.inc"
INCLUDE "helpers.inc"
INCLUDE "common/vblank.inc"
INCLUDE "gfx.inc"

DEF TILES_PER_BATCH EQU 0x40

SECTION "BIOSMAIN", ROMX

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;load tiles and tilemap
;perform ram and rom tests and print their results
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
biosMain::
	swapRamBank gfx_task_queue
	
	;request tile graphics tasks
	ld de, bios_tile_tasks
	ld c, 0x100/TILES_PER_BATCH
	.submitLoop:
		call queueGfxTask
		dec c
	jr nz, .submitLoop
	
	;copy palettes into shadow memory
	ld hl, shadow_palettes_bkg
	ld de, bios_colors
	ldsize c, bios_colors
	rst memcpy
	
	;and request they get loaded
	ldh a, [redraw_screen]
	or RELOAD_PALETTES
	ldh [redraw_screen], a
	
	;clear the screen with space character	
	ld hl, shadow_bkg_map
	ldsize bc, shadow_bkg_map
	ld a, " "
	.clearScreen:
		rst memset
		dec b
	jr nz, .clearScreen
	
	;print header
	ld de, bios_strings
	ldcoord hl, shadow_bkg_map, 1, 1
	rst strcpy
	
	;print ram test
	ldcoord hl, shadow_bkg_map, 2, 3
	rst strcpy
	
	;get number of banks and print it
	push hl
	call_banked ramTest ;returns b = number of banks
	call bcd11 ;returns bc = string
	pop hl
	printBCD b, c	
	rst strcpy ;de still points to the "KB" suffix
	
	;check if its good and print either "X" or "OK"
	ld a, c
	sub 0x28
	ld a, b
	sbc 0x01
	ld a, "X"
	jr c, .badRam
		ld a, "O"
		ldi [hl], a
		ld a, "K"
	.badRam:
	ldi [hl], a	
	
	;print footer. TODO make romtest work like above
	ldcoord hl, shadow_bkg_map, 2, 4
	rst strcpy
	rst strcpy
	
	;request screen to display new map
	ld de, bios_map_task
	call queueGfxTask
	restoreRamBank
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;converts 11 bit binary number to 4 digit bcd
;we can optimize since the lower 3 bits are always 0
;inputs: b = number (binary)
;outputs: bc = number (bcd)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bcd11:
	;the "double dabble" routine shifts the number one place to the left every loop.
	;then, for every nibble that is >= 5, it will add 3.
	;this causes the nibbles to carry at 10 instead of 16, creating a decimal number.
	;instead, we use the "daa" instruction which adds 6 when the nibble is >= 10, which accomplishes the same thing.
	;we can optimize by only daa-ing when we know a carry is possible, which is at powers of 100	

	;the first 4 bits can only generate one half-carry (0-15), so we don't need to double dabble them.
	swap b
	ld a, b
	and 0x0F
	or a
	daa ;a = 0-15 and b has 4 useful bits left. unfortunately the other 4 bits contain garbage that will stick around this entire process.
	
	;the next 3 bits can only generate one full carry (0-127), so avoid 16-bit processing for now
	ld c, 0x03
	.loop127:
		sla b
		adc a
		daa
		dec c
	jr nz, .loop127
	
	;at this point, A contains the lower 2 digits, carry flag contains the 100s place if present, b contains 1 useful bit
	rl b ;simultaneously store b = hundreds digit and carry = next bit to process. right now register "BA" contains 0-127
	adc a
	daa
	ld c, a
	ld a, b
	adc a
	daa ;"AC" contains 0-255, except the top bits of A contain garbage from when we did "swap b" at the beginning
	and 0x03 ;remove the garbage
	ld b, a ;bc = 0-255
	
	;the last 3 iterations now must be done with the full 16 bit processing as normal.
	ld l, 0x03
	.loop2040:
		ld a, c
		add a ;normally we would left shift the buffer here, but the last 3 bits are always 0 (1 bank = 8K) so we can shift in the 0 ourselves
		daa
		ld c, a
		ld a, b
		adc a
		daa
		ld b, a
		dec l
	jr nz, .loop2040
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

bios_strings:
	db "GBLINUX BIOS v0.1", 0
	db "RAM TEST ", 0
	db "K ", 0
	db "ROM TEST ", 0
	db "SOON", 0

bios_colors:
	dw 0xFFFF, 0x4210, 0x0000, 0x0000
	.end:

bios_map_task:
	GFXTASK shadow_bkg_map, 0, vram_bkg_map, 0

bios_tile_tasks:
DEF I = 0
REPT 0x100/TILES_PER_BATCH
	GFXTASK bios_tile_data, I*TILES_PER_BATCH*0x10, vram_tile_mem_1, I*TILES_PER_BATCH*0x10, TILES_PER_BATCH
	DEF I = I + 1
ENDR
	
SECTION "BIOSTILES", ROMX
bios_tile_data:
	INCBIN "./src/bios/font.bin"