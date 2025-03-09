INCLUDE "hwregs.inc"

SECTION "HELPERS", ROM0
banked::
	ldh a, [rom_bank]
	push af
	ld a, b
	ld [MBC_ROM_BANK], a
	rst callHL
	pop af
	ldh [rom_bank], a
	ld [MBC_ROM_BANK], a
	ret	
