DEF TILES_PER_BATCH EQU (0x40 - 1)

SECTION "BIOSMAIN", ROMX
biosMain::
	swapRamBank gfx_task_tail
	ld de, bios_tile_tasks
	ld c, 0x04
	.submitLoop:
		call queueGfxTask
		dec c
	jr nz, .submitLoop
	
	.wait:
		call waitFrame
		ld hl, gfx_task_tail
		ldi a, [hl]
		sub [hl]
	jr nz, .wait
	
	ld hl, shadow_bkg_map
	ldsize bc, shadow_bkg_map
	xor a
	.clearScreen:
		rst memset
		dec b
	jr nz, .clearScreen
	
	ld de, bios_strings
	ldoord hl, shadow_bkg_map, 1, 1
	rst strcpy
	ldoord hl, shadow_bkg_map, 2, 3
	rst strcpy
	call_banked ramTest
	ld a, b
	cp 0x10
	jr z, .ramOK
	
	.ramOK:
	rst strcpy
	ldcoord hl, shadow_bkg_map, 2, 4
	rst strcpy
	rst strcpy
	ret
	
	
	
		RAM TEST 128K OK
bios_strings:
	db "GBLINUX BIOS v0.1", 0
	db "RAM TEST ", 0
	db "128K OK", 0
	db "ROM TEST ", 0
	db "64K OK", 0

bios_map_task:
	GFXTASK shadow_bkg_map, 0, 0x9800, 0

bios_tile_tasks:
SET I = 0
REPT 4
	GFXTASK bios_tile_data, I*TILES_PER_BATCH*0x10, 0x8800, I*TILES_PER_BATCH*0x10, TILES_PER_BATCH*0x10
	I = I + 1
	
SECTTION "BIOSTILES", ROMX
bios_tile_data:
	INCBIN "./src/bios/font.bin"