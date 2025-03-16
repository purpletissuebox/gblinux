MACRO ldsize
ld \1, (\2.end - \2)
ENDM

MACRO swapRomBank
ldh a, [rom_bank]
push af
ld a, BANK(\1)
ld [MBC_ROM_BANK], a
ENDM

MACRO swapRamBank
ldh a, [ram_bank]
push af
ld a, BANK(\1)
ldh [IO_WRAM_BANK], a
ENDM

MACRO restoreRomBank
pop af
ld [MBC_ROM_BANK], a
ENDM

MACRO restoreRamBank
pop af
ldh [IO_WRAM_BANK], a
ENDM

MACRO ldcoord
ld \1, \2 + ((\4 << 5) | \3)
ENDM

MACRO printBCD
REPT _NARG
	ld a, \1
	and 0xF0
	swap a
	add "0"
	ldi [hl], a
	ld a, \1
	and 0x0F
	add "0"
	ldi [hl], a
	shift
ENDR
ENDM