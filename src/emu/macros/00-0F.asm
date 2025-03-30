INCLUDE "hwregs.inc"

SECTION "EMU_MACRO_00", ROM0

emu_macro_00:: ;RETURN
	;disOneInstruction
	;hl
	;runInstructionMacros <--sp
	add sp, 4
	ret

SECTION "EMU_MACRO_01", ROM0
emu_macro_01:: ;N/A
	ret
SECTION "EMU_MACRO_02", ROM0
emu_macro_02:: ;N/A
	ret
SECTION "EMU_MACRO_03", ROM0
emu_macro_03:: ;N/A
	ret
	
SECTION "EMU_MACRO_04", ROM0
emu_macro_04:: ;INCPC
	inc c
		ret nz
	inc b
	bit 7, b
		ret z
	push af
	ldh a, [rom_bank]
	inc a
	ldh [rom_bank], a
	ld [MBC_ROM_BANK], a
	pop af
	ld b, 0x40
	ret
	
SECTION "EMU_MACRO_05", ROM0
emu_macro_05:: ;DECPC
	dec bc
	bit 6, b
		ret nz
	push af
	ldh a, [rom_bank]
	dec a
	ldh [rom_bank], a
	ld [MBC_ROM_BANK], a
	pop af
	ld b, 0x7F
	ret

SECTION "EMU_MACRO_06", ROM0
emu_macro_06:: ;N/A
	ret
SECTION "EMU_MACRO_07", ROM0
emu_macro_07:: ;N/A
	ret
SECTION "EMU_MACRO_08", ROM0
emu_macro_08:: ;JMP
	add sp, 2
	pop hl
	
	ldi a, [hl]
	ld h, [hl]
	ld l, a
	
	push hl
	add sp, -2
	ret
	
SECTION "EMU_MACRO_09", ROM0
emu_macro_09:: ;N/A
	ret
SECTION "EMU_MACRO_0A", ROM0
emu_macro_0A:: ;N/A
	ret
SECTION "EMU_MACRO_0B", ROM0
emu_macro_0B:: ;N/A
	ret
SECTION "EMU_MACRO_0C", ROM0
emu_macro_0C:: ;RET
	ret	
SECTION "EMU_MACRO_0D", ROM0
emu_macro_0D:: ;N/A
	ret
SECTION "EMU_MACRO_0E", ROM0
emu_macro_0E:: ;N/A
	ret
SECTION "EMU_MACRO_0F", ROM0
emu_macro_0F:: ;N/A
	ret