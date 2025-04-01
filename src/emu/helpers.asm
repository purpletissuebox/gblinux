INCLUDE "macros.inc"
INCLUDE "hwregs.inc"

SECTION "DIS_HELPERS", ROM0
printR1_8_bc::
	ld a, [bc]
printR1_8_a::
	swap a
	rlca
	and 0x07
	jp printReg8

printR1_16_bc::
	ld a, [bc]
printR1_16_a::
	swap a
	rlca
	and 0x07
	jp printReg16

printR2_8_bc::
	printl "["
	ld a, [bc]
	and 0x07
	ld h, a
	ld a, [bc]
	call incbc
	
	add a
	jr c, .mode23
		add a
		ld a, h
		jr c, .mode1
			call printR2_mode0
			jr .done
		.mode1:
			call printR2_mode1
			jr .done
	.mode23:
		add a
		ld a, h
		jr nc, .mode2
			dec de
			jp printR1_8_a
	.mode2:
			call printR2_mode2
	.done:
	printl "]"
	ret

printR2_16_bc::
	printl "["
	ld a, [bc]
	and 0x07
	ld h, a
	ld a, [bc]
	call incbc
	
	add a
	jr c, .mode23
		add a
		ld a, h
		jr c, .mode1
			call printR2_mode0
			jr .done
		.mode1:
			call printR2_mode1
			jr .done
	.mode23:
		add a
		ld a, h
		jr nc, .mode2
			dec de
			jp printR1_8_a
		.mode2:
			call printR2_mode2
	.done:
	printl "]"
	ret

printR2_mode0:
	cp 0x06
	jp nz, printMem
	jp printImm16_bc

printR2_mode1:
	call printMem
	printl "+"
	jp printImm8_bc

printR2_mode2:
	call printMem
	printl "+"
	jp printImm16_bc

printSegment::
	add 8
printReg16::
	add 8
printReg8::
	add a
	add LOW(register_names)
	ld l, a
	adc HIGH(register_names)
	sub l
	ld h, a
	ldi a, [hl]
	ld [de], a
	inc de
	ldi a, [hl]
	ld [de], a
	inc de
	ret

printMem:
	ld l, a
	add a
	add a
	add l
	add LOW(memory_names)
	ld l, a
	adc HIGH(register_names)
	sub l
	ld h, a
	REPT 5
		ldi a, [hl]
		ld [de], a
		inc de
	ENDR
	ret

printImm8_bc::
	ld a, [bc]
	call incbc
printImm8_a::
	ld l, a
	and 0xF0
	swap a
	cp 0x0A
	jr c, .small
		add "A" - "9" - 1
	.small:
	add "0"
	ld [de], a
	inc de
	ld a, l
	and 0x0F
	cp 0x0A
	jr c, .small2
		add "A" - "9" - 1
	.small2:
	add "0"
	ld [de], a
	inc de
	ret

printImm16_bc::
	ld a, [bc]
	ld h, a
	call incbc
	call printImm8_bc
	ld a, h
	jp printImm8_a
	
incbc::
	inc c
		ret nz
	inc b
	bit 6, b
		ret nz
	push af
	ldh a, [rom_bank]
	inc a
	ldh [rom_bank], a
	ld [MBC_ROM_BANK], a
	pop af
	ld b, 0x40
	ret

register_names:
	db "ALCLDLBLAHCHDHBHAXCXDXBXSPBPSIDIESCSSSDS"
memory_names:
	db "BX+SIBX+DIBP+SIBP+DISI   DI   BP   BX   "
