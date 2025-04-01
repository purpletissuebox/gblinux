INCLUDE "macros.inc"

SECTION "UNUSED_2", ROM0
opcode_handler_C0:: ;UNUSED
	ld a, l
opcode_handler_C1:: ;UNUSED
	printl "db "
	ld a, l
	sub (LOW(opcode_handler_C0) - 0xC0)
	jp printImm8_a
opcode_handler_C8:: ;UNUSED
	ld a, l
opcode_handler_C9:: ;UNUSED
	printl "db "
	ld a, l
	sub (LOW(opcode_handler_C8) - 0xC0)
	jp printImm8_a
opcode_handler_D6:: ;UNUSED
	printl "db D6"
opcode_handler_F1:: ;UNUSED
	printl "db F0"
	ret

SECTION "MISC", ROM0
opcode_handler_EA:: ;JMP.f
	call printImm16_bc
	printl ":"
opcode_handler_C2:: ;RET imm
opcode_handler_CA:: ;RET.f imm
opcode_handler_E8:: ;CALL
opcode_handler_E9:: ;JMP
	jp printImm16_bc
opcode_handler_C3:: ;RET
opcode_handler_CB:: ;RET.f
opcode_handler_CF:: ;RETI
opcode_handler_D4:: ;AAM
opcode_handler_D5:: ;AAD
opcode_handler_D7:: ;XLATB
opcode_handler_F4:: ;HALT
opcode_handler_F5:: ;CMC
opcode_handler_F8:: ;CLC
opcode_handler_F9:: ;STC
opcode_handler_FA:: ;CLI
opcode_handler_FB:: ;STI
opcode_handler_FC:: ;CLD
opcode_handler_FD:: ;STD
	ret

SECTION "DOUBLEWORD_LOADS", ROM0
opcode_handler_C4:: ;LES
opcode_handler_C5:: ;LDS
	printl "AX, "
	jp printR2_16_bc

SECTION "MOV_IMM_MEM", ROM0
opcode_handler_C6:: ;MOV.b r/m, imm
	call printR2_8_bc
	printl ", "
	jp printImm8_bc
opcode_handler_C7:: ;MOV.w r/m, imm
	call printR2_16_bc
	printl ", "
	jp printImm16_bc

SECTION "INTERRUPTS", ROM0
opcode_handler_CC:: ;INT 3
	printl "3"
	ret
opcode_handler_CD:: ;INT imm
	jp printImm8_bc
opcode_handler_CE:: ;INT.o 4
	printl "4"
	ret

SECTION "SHIFT", ROM0
opcode_handler_D0:: ;SHIFT.b r/m, 1
opcode_handler_D1:: ;SHIFT.w r/m, 1
opcode_handler_D2:: ;SHIFT.b r/m, CX
opcode_handler_D3:: ;SHIFT.w r/m, CX
	ret

SECTION "ESCAPE", ROM0
opcode_handler_D8:: ;ESC 0
	ld a, l
opcode_handler_D9:: ;ESC 1
	ld a, l
opcode_handler_DA:: ;ESC 2
	ld a, l
opcode_handler_DB:: ;ESC 3
	ld a, l
opcode_handler_DC:: ;ESC 4
	ld a, l
opcode_handler_DD:: ;ESC 5
	ld a, l
opcode_handler_DE:: ;ESC 6
	ld a, l
opcode_handler_DF:: ;ESC 7
	ld a, l
	sub LOW(opcode_handler_D8)
	jp printImm8_a

SECTION "MISC_JUMPS", ROM0
opcode_handler_E0:: ;LOOPNZ
opcode_handler_E1:: ;LOOPZ
opcode_handler_E2:: ;LOOP
opcode_handler_E3:: ;JCXZ
opcode_handler_EB:: ;JMP
	jp printImm8_bc

SECTION "IN_N_OUT_BURGER", ROM0
opcode_handler_E4:: ;IN AL, imm
	ld a, 1
	ld a, l
opcode_handler_E5:: ;IN AX, imm
	printl "A"
	ld a, l
	sub LOW(opcode_handler_E4)
	add a
	add a
	add "L"
	ld [de], a
	inc de
	printl ", "
	jp printImm8_bc
opcode_handler_E6:: ;OUT imm, AL
	ld a, 1
	ld a, l
opcode_handler_E7:: ;OUT imm, AX
	ld a, l
	sub LOW(opcode_handler_E6)
	add a
	add a
	add "L"
	ld h, a
	call printImm8_bc
	printl ", A"
	ld a, h
	ld [de], a
	inc de
	ret
opcode_handler_EC:: ;INALDX
	ld a, l
opcode_handler_ED:: ;INAXDX
	ld a, l
opcode_handler_EE:: ;OUTDXAL
	ld a, l
opcode_handler_EF:: ;OUTDXAX
	ld a, l
	add a
	add a
	add LOW(.texts)
	ld l, a
	adc HIGH(.texts)
	sub l
	ld h, a
	ldi a, [hl]
	.loop:
		ld [de], a
		inc de
		ldi a, [hl]
		cp ","
	jr nz, .loop
	.loop2:
		ld [de], a
		inc de
		ldi a, [hl]
		cp ","
	jr nz, .loop2
	ret
.texts:
	db "AL, "
	db "DX, "
	db "AX, "
	db "DX, "
	db "AL, "

SECTION "PREFIX", ROM0
opcode_handler_F0:: ;LOCK
opcode_handler_F2:: ;REPNZ
opcode_handler_F3:: ;REPZ
	jp disOneInstruction

SECTION "GROUP", ROM0
opcode_handler_F6:: ;GRP1.b
opcode_handler_F7:: ;GRP1.w
opcode_handler_FE:: ;GRP2.b
opcode_handler_FF:: ;GRP2.w
	ret