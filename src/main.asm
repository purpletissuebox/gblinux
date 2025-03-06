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
  jp ram_test
	
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

SECTION "RAMTEST", ROMX
ram_test::
  ld a, 0x0A
  ld [0x0000], a
  ld c, 0x22
  ld b, 16  ;i = 16
  .write_test:
    ld a, b            ;load curr bank
    ld [0x4000], a     ;Set SRAM bank 
    ld a, c            ;Load dummy value
    ld [0xA000], a     ;Load dummy value to mem 
    dec b              ;i--
    jr nz, .write_test ;while (i> 0)
  ld b, 16             ;reload i = 16
  .read_test:
    ld a, b
    ld [0x4000], a 
    ld a, [0xA000]
    cp c
    jr nz, .ram_failure ;didn't get same value back
    dec b 
    jr nz, .read_test    ; i > 0 
  .success:
    ;do something. go to next step
    jp end
  .ram_failure: 
    ;exit
    
