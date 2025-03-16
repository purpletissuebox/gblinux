INCLUDE "hwregs.inc"

SECTION "VECTORS", ROM0[0x0000]
callHL::
	jp hl
	ds 0x0008 - @
memcpy::
	ld a, [de]
	inc de
	ldi [hl], a
	dec c
	jr nz, memcpy
	ret
	ds 0x0010 - @
strcpy::
	ld a, [de]
	inc de
	and a
	ret z
	ldi [hl], a
	jr strcpy
	ds 0x0018 - @
waitVRAM::
	;routine takes 44 dots at most, ppu takes 167 dots at least.
	;so worst case you have 123 dots = 30 clocks of vram time after calling this
	ldh a, [IO_LCD_STATUS]
	and (PPU_MODE & 2)
	jr nz, waitVRAM
	ret
	ds 0x0020 - @
memset::
	ldi [hl], a
	dec c
	jr nz, memset
	ret
	ds 0x0028 - @
rst_28::
	ret
	ds 0x0030 - @
rst_30::
	ret
	ds 0x0038 - @
rst_38::
	jr rst_38
	ds 0x0040 - @
	
int_vblank::
	push af
	ldh a, [redraw_screen]
	and a
	jp nz, VBLANK
	pop af
	ds 0x0048 - @
int_lcd::
	reti
	ds 0x0050 - @
int_timer::
	reti
	ds 0x0058 - @
int_serial::
	reti
	ds 0x0060 - @
int_joypad::
	reti

SECTION "HEADER", ROM0[0x0100]
entryPoint:
	nop
	jp init

ds $150-@ ;reserve space for logo, etc

SECTION "MAIN", ROM0
MAIN::
	call biosMain
	.loop:
		halt
	jr MAIN.loop

SECTION "RAMTEST", ROMX
ramTest::
  ld a, 0x0A
  ld [MBC_RAM_ENABLE], a    ;Enable SRAM 
  ld c, 0x22                ;dummy value for writing
  ld d, 0x0F                ;i = 15, banks 0-15
  ld b, 0x00                ;number of banks read successfully
  ld a, b                   ;load first bank, loop will handle others
  .write_test:
    ld [MBC_RAM_BANK], a    ;Set SRAM bank 
    ld a, c                 ;Load dummy value
    ld [0xA000], a          ;Load dummy value to mem
    dec d                   ;i--
    ld a, d                 ;prepare for next bank
    cp 0xFF                 ;dec'd b past 0, done 
    jr z, .write_done
    jr .write_test          ;while (i> 0), go again when we hit 0 for the 0 bank below
  .write_done:
    ld d, 0x0F              ;reload i = 15
    ld a, d                 ;load current bank, loop gets rest
  .read_test:
    ld [MBC_RAM_BANK], a    ;set SRAM bank 
    ld a, [0xA000]          ;Load memory value to a
    cp c
    jr nz, .read_failure    ;skip inc d as bank is not working, and keep chugging to dec b
    inc b                   ;+1 working bank
  .read_failure:            ; will run even if no failure, simply a label for jr above
    dec d                   ;i--
    ld a, d                 ;prepare for next bank
    cp 0xFF
    jr z, .exit             ;if we dec past 0, quit
  jr .read_test             ;
  .exit:
    ret                     ;b = number of banks successfully read
