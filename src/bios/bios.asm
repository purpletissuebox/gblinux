INCLUDE "hwregs.inc"
INCLUDE "macros.inc"
INCLUDE "helpers.inc"
INCLUDE "common/vblank.inc"
INCLUDE "gfx.inc"

DEF TILES_PER_BATCH EQU 0x40

SECTION "BIOSMAIN", ROMX
biosMain::
	swapRamBank gfx_task_tail
	ld de, bios_tile_tasks
	ld c, 0x04
	.submitLoop:
		call queueGfxTask
		dec c
	jr nz, .submitLoop
	
	ld hl, shadow_palettes_bkg
	ld de, bios_colors
	ldsize c, bios_colors
	rst memcpy
	ldh a, [redraw_screen]
	or RELOAD_PALETTES
	ldh [redraw_screen], a
	
	ld hl, shadow_bkg_map
	ldsize bc, shadow_bkg_map
	ld a, " "
	.clearScreen:
		rst memset
		dec b
	jr nz, .clearScreen
	
	ld de, bios_strings
	ldcoord hl, shadow_bkg_map, 1, 1
	rst strcpy
	ldcoord hl, shadow_bkg_map, 2, 3
	rst strcpy
	push hl
	call_banked ramTest
	pop hl
	
	ld a, b
	add a
	add a
	add LOW(bios_ram_amts)
	ld c, a
	adc HIGH(bios_ram_amts)
	sub c
	ld b, a
	REPT 3
		ld a, [bc]
		inc bc
		ldi [hl], a
	ENDR	
	
	rst strcpy
	ld a, [bc]
	and a
	jr nz, .badRam
		ld a, "O"
		ldi [hl], a
		ld a, "K"
	.badRam:
	ldi [hl], a	
	
	ldcoord hl, shadow_bkg_map, 2, 4
	rst strcpy
	rst strcpy
	
	ld de, bios_map_task
	call queueGfxTask
	restoreRamBank
	ret

bios_ram_amts:
	db "000 008 016 024 032 040 048 056 064 072 080 088 096 104 112 120 128", 0

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