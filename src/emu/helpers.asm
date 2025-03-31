INCLUDE "macros.inc"
INCLUDE "hwregs.inc"

SECTION "DIS_HELPERS", ROM0
printR1_8::
	ld a, [bc]
	call getR1
	jp printReg8

printR1_16::
	ld a, [bc]
	call getR1
	jp printReg16

printR2_8::
	printl "["
	ld a, [bc]
	and 0x07
	ld h, a
	ld a, [bc]
	
	add a
	jr c, .mode23
		add a
		jr c, .mode1
		call printR2_mode0
		jr .done
	.mode1:
		call printR2_mode1
		jr .done
	.mode23:
		add a
		jr c, .mode3
		call printR2_mode2
		jr .done
	.mode3:
		dec de
		call printR1_8
	.done:
	printl "]"
	ret

printR2_16::
	printl "["
	ld a, [bc]
	and 0x07
	ld h, a
	ld a, [bc]
	
	add a
	jr c, .mode23
		add a
		jr c, .mode1
		call printR2_mode0
		jr .done
	.mode1:
		call printR2_mode1
		jr .done
	.mode23:
		add a
		jr c, .mode3
		call printR2_mode2
		jr .done
	.mode3:
		dec de
		call printR1_8
	.done:
	printl "]"
	ret

printR2_mode0:
	cp 0x06
	jp nz, printMem
	jp printImm16

printR2_mode1:
	call printMem
	call incbc
	printl "+"
	jp printImm8

printR2_mode2:
	call printMem
	call incbc
	printl "+"
	jp printImm16

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

printImm8::
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

printImm16::
	ld a, [bc]
	ld h, a
	call incbc
	ld a, [bc]
	call printImm8
	ld a, h
	jp printImm8
	
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
	ld b, 0x40

getR1:
	ld a, [bc]
	swap a
	rlca
	and 0x07
	ret

register_names:
	db "ALCLDLBLAHCHDHBHAXCXDXBXSPBPSIDIESCSSSDS"
memory_names:
	db "BX+SIBX+DIBP+SIBP+DISI   DI   BP   BX   "
