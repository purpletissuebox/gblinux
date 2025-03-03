INCLUDE "hwregs.inc"

SECTION "MEMCPY", ROM0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;memcpy is part of the reset vectors - see main.asm
;copies data from one place to another
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

memcpy_big::
	ld a, c
	and a
	jr z, memcpy_big.copyB
	inc b
	
	.copyB
		.copyC:
			ld a, [de]
			inc de
			ldi [hl], a
			dec c
		jr nz, memcpy_big.copyC
		dec b
	jr nz, memcpy_big.copyB
	ret

memcpy_banked::
	ld a, b
	ld [MBC_ROM_BANK], a
	jp memcpy

memcpy_banked_tiles::
	ld a, b
	ld [MBC_ROM_BANK], a
	
	ld a, c
	swap a
	and $0F
	ld b, a
	ld a, c
	swap a
	and $F0
	ld c, a
	jp memcpy