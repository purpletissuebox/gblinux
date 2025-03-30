INCLUDE "macros.inc"
INCLUDE "hwregs.inc"

SECTION "8086TEST", ROMX
test8086:
	db $A1, $44, $BC, $C7, $5A, $EA, $D7, $87, $32, $84, $21, $65, $BE, $E6, $F4, $82, $89, $1E, $22, $48, $16, $CE, $57, $32, $D8, $93, $4F, $48, $E2, $5D, $6A, $83, $84, $10, $B3, $73, $61, $CC, $9A, $28, $00, $36, $AD, $AA, $84, $8D, $00, $93, $DB, $F8, $E4, $29, $19, $39, $7C, $CB, $69, $A0, $7B, $50, $70, $58, $43, $35, $94, $1F, $72, $C5, $6E, $30, $16, $3F, $96, $7D, $FD, $95, $6E, $9F, $A3, $B3, $95, $62, $55, $88, $6B, $A3, $4E, $19, $64, $E7, $83, $69, $5C, $A6, $FC, $FD, $C6, $5D, $D3, $15, $60, $DD, $7F, $EC, $CE, $14, $22, $D1, $60, $BF, $38, $C5, $63, $86, $CF, $43, $76, $FB, $FE, $44, $98, $AC, $C9, $B3, $4E, $83, $0B

SECTION "8086DIS", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dis::
	ld a, BANK(test8086)
	ld [MBC_ROM_BANK], a
	ld bc, test8086
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
	adc HIGH(opcode_name_table)
	sub l
	ld h, a
	ldi a, [hl]
	ld h, [hl]
	ld l, a
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