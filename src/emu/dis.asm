INCLUDE "macros.inc"
INCLUDE "hwregs.inc"

SECTION "8086DIS", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dis::
	swapRamBank shadow_bkg_map
	call getMapTL
	ld a, 18
	.print:
		ldh [scratch], a
		call disOneInstruction
		ld a, e
		or 0x1F
		ld e, a
		inc de
		res 2, d
		ldh a, [scratch]
		dec a
	jr nz, .print
	restoreRamBank
	ret

getMapTL:
	ld a, [shadow_scroll_y]
	ld d, 0
	add a
	rl d
	add a
	rl d
	and 0xE0
	ld e, a
	ld a, d
	add HIGH(shadow_bkg_map)
	ld d, a
	ret

disOneInstruction:
	ld a, [bc]
	call print_op
	ld a, [bc]
	inc bc
	
	add a
	ld l, a
	adc HIGH(opcode_handler_table)
	sub l
	ld h, a
	
	ldi a, [hl]
	ld h, [hl]
	ld l, a
	call runInstructionMacros
	pop bc
	ret

print_op:
	add a
	ld l, a
	adc HIGH(opcode_names)
	sub l
	ld h, a
	.loop:
		ldi a, [hl]
		and a
			ret z
		ld [de], a
		inc de
	jr .loop
	ret

runInstructionMacros:
		ldi a, [hl]
		push hl
		add a
		ld l, a
		adc HIGH(macro_jump_table)
		sub l
		ld h, a
		ldi a, [hl]
		ld h, [hl]
		ld l, a
		rst callHL
		pop hl
	jr runInstructionMacros

opcode_handler_table:
	align 8
	DEF I = 0
	REPT 256
		dw opcode_handler_{02X:I}
		DEF I = I+1
	ENDR

macro_jump_table:
	align 8
	DEF I = 0
	REPT 256
		dw emu_macro_{02X:I}
		DEF I = I+1
	ENDR

INCLUDE "src/emu/opcodes.dat"