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
opcode_handler_C2:: ;RET imm
opcode_handler_CA:: ;RET.f imm
	jp printImm16_bc
opcode_handler_C3:: ;RET
opcode_handler_CB:: ;RET.f
opcode_handler_CF:: ;RETI
opcode_handler_D4:: ;AAM
opcode_handler_D5:: ;AAD
opcode_handler_D7:: ;XLATB
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

opcode_handler_D8:: ;
opcode_handler_D9:: ;
opcode_handler_DA:: ;
opcode_handler_DB:: ;
opcode_handler_DC:: ;
opcode_handler_DD:: ;
opcode_handler_DE:: ;
opcode_handler_DF:: ;
opcode_handler_E0:: ;
opcode_handler_E1:: ;
opcode_handler_E2:: ;
opcode_handler_E3:: ;
opcode_handler_E4:: ;
opcode_handler_E5:: ;
opcode_handler_E6:: ;
opcode_handler_E7:: ;
opcode_handler_E8:: ;
opcode_handler_E9:: ;
opcode_handler_EA:: ;
opcode_handler_EB:: ;
opcode_handler_EC:: ;
opcode_handler_ED:: ;
opcode_handler_EE:: ;
opcode_handler_EF:: ;
opcode_handler_F0:: ;
opcode_handler_F2:: ;
opcode_handler_F3:: ;
opcode_handler_F4:: ;
opcode_handler_F5:: ;
opcode_handler_F6:: ;
opcode_handler_F7:: ;
opcode_handler_F8:: ;
opcode_handler_F9:: ;
opcode_handler_FA:: ;
opcode_handler_FB:: ;
opcode_handler_FC:: ;
opcode_handler_FD:: ;
opcode_handler_FE:: ;
opcode_handler_FF:: ;
	ret