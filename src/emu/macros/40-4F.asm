SECTION "EMU_PRINT_REGS", ROM0
emu_macro_42:: ;PRINTSEG
	add 0x08
emu_macro_41:: ;PRINTR16
	add 0x08
emu_macro_40:: ;PRINTR8
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

emu_macro_43:: ;PRINTMEM
	ld l, a
	add a
	add a
	add l
	add LOW(memory_names)
	ld l, a
	adc HIGH(memory_names)
	ld h, a
	REPT 5
		ldi a, [hl]
		ld [de], a
		inc de
	ENDR
	ret
	
register_names:
	db "ALCLDLBLAHCHDHBHAXCXDXBXSPBPSIDIESCSSSDS"
memory_names:
	db "BX+SIBX+DIBP+SIBP+DISI   DI   BP   BX   "
	ret

SECTION "EMU_PRINT_LITERAL", ROM0
emu_macro_43:: ;N/A
	jp copy
	db 0xFF
emu_macro_44:: ;N/A
	jp copy
	db 0xFF
emu_macro_45:: ;N/A
	jp copy
	db 0xFF
emu_macro_46:: ;N/A
	jp copy
	db 0xFF
emu_macro_47:: ;N/A
	jp copy
	db 0xFF
emu_macro_48:: ;N/A
	jp copy
	db 0xFF
emu_macro_49:: ;N/A
	jp copy
	db 0xFF
emu_macro_4A:: ;N/A
	jp copy
	db 0xFF
emu_macro_4B:: ;N/A
	jp copy
	db 0xFF
emu_macro_4C:: ;N/A
	jp copy
	db 0xFF
emu_macro_4D:: ;N/A
	jp copy
	db 0xFF
emu_macro_4E:: ;N/A
	jp copy
	db 0xFF
emu_macro_4F:: ;N/A
	jp copy
	db 0xFF
copy:
	ld a, l
	sub (LOW(emu_macro_43)-4)
	push bc
	ld c, a
	add sp, 4
	pop hl
	.loop:
		ldi a, [hl]
		ld [de], a
		inc de
		dec c
	jr nc, .loop
	push hl
	add sp, -4
	pop bc
	ret
