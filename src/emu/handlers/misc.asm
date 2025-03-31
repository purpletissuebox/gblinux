INCLUDE "macros.inc"

SECTION "IMM_GROUP", ROM0
opcode_handler_80:: ;INC AX
opcode_handler_81:: ;DEC AX
opcode_handler_82:: ;PUSH AX
opcode_handler_83:: ;POP AX
	ret

SECTION "ATOMIC_OPS_B", ROM0
opcode_handler_84:: ;TEST.b reg, r/m
opcode_handler_86:: ;XCHG.b reg, r/m
opcode_handler_8A:: ; MOV.b reg, r/m
	call printR1_8_bc
	printl ", "
	call printR2_8_bc
	jp incbc

SECTION "ATOMIC_OPS_W", ROM0
opcode_handler_85:: ;TEST.w reg, r/m
opcode_handler_87:: ;XCHG.w reg, r/m
opcode_handler_8B:: ; MOV.w reg, r/m
opcode_handler_8D:: ; LEA.w reg, r/m
	call printR1_16_bc
	printl ", "
	call printR2_16_bc
	jp incbc

SECTION "EXTRA_MOVS", ROM0
opcode_handler_88:: ;MOV.b r/m, reg
	ld a, [bc]
	push af
	call printR2_8_bc
	printl ", "
	pop af
	call printR1_8_a
	jp incbc
opcode_handler_89:: ;MOV.w r/m, reg
	ld a, [bc]
	push af
	call printR2_16_bc
	printl ", "
	pop af
	call printR1_16_a
	jp incbc

SECTION "SEGMENT_TO_MEMORY", ROM0
opcode_handler_8C:: ;MOV.w r/m, seg
	ld a, [bc]
	push af
	call printR2_16_bc
	printl ", "
	pop af
	jp printSegment
opcode_handler_8E:: ;MOV.w seg, r/m
	ld a, [bc]
	call printSegment
	printl ", "
	jp printR2_16_bc

SECTION "EXTRA_POP", ROM0
opcode_handler_8F:: ;POP r/m
	jp printR2_16_bc

SECTION "EXCHANGE_AX", ROM0
opcode_handler_90:: ;XCHG , AX
	ret
opcode_handler_91:: ;XCHG , AX
	ld a, l
opcode_handler_92:: ;XCHG , AX
	ld a, l
opcode_handler_93:: ;XCHG , AX
	ld a, l
opcode_handler_94:: ;XCHG , AX
	ld a, l
opcode_handler_95:: ;XCHG , AX
	ld a, l
opcode_handler_96:: ;XCHG , AX
	ld a, l
opcode_handler_97:: ;XCHG , AX
	ld a, l
	sub LOW(opcode_handler_90)
	call printReg16
	printl ", AX"

SECTION "NOT_DONE", ROM0
opcode_handler_98:: ;
opcode_handler_99:: ;
opcode_handler_9A:: ;
opcode_handler_9B:: ;
opcode_handler_9C:: ;
opcode_handler_9D:: ;
opcode_handler_9E:: ;
opcode_handler_9F:: ;
opcode_handler_A0:: ;
opcode_handler_A1:: ;
opcode_handler_A2:: ;
opcode_handler_A3:: ;
opcode_handler_A4:: ;
opcode_handler_A5:: ;
opcode_handler_A6:: ;
opcode_handler_A7:: ;
opcode_handler_A8:: ;
opcode_handler_A9:: ;
opcode_handler_AA:: ;
opcode_handler_AB:: ;
opcode_handler_AC:: ;
opcode_handler_AD:: ;
opcode_handler_AE:: ;
opcode_handler_AF:: ;
opcode_handler_B0:: ;
opcode_handler_B1:: ;
opcode_handler_B2:: ;
opcode_handler_B3:: ;
opcode_handler_B4:: ;
opcode_handler_B5:: ;
opcode_handler_B6:: ;
opcode_handler_B7:: ;
opcode_handler_B8:: ;
opcode_handler_B9:: ;
opcode_handler_BA:: ;
opcode_handler_BB:: ;
opcode_handler_BC:: ;
opcode_handler_BD:: ;
opcode_handler_BE:: ;
opcode_handler_BF:: ;
opcode_handler_C0:: ;
opcode_handler_C1:: ;
opcode_handler_C2:: ;
opcode_handler_C3:: ;
opcode_handler_C4:: ;
opcode_handler_C5:: ;
opcode_handler_C6:: ;
opcode_handler_C7:: ;
opcode_handler_C8:: ;
opcode_handler_C9:: ;
opcode_handler_CA:: ;
opcode_handler_CB:: ;
opcode_handler_CC:: ;
opcode_handler_CD:: ;
opcode_handler_CE:: ;
opcode_handler_CF:: ;
opcode_handler_D0:: ;
opcode_handler_D1:: ;
opcode_handler_D2:: ;
opcode_handler_D3:: ;
opcode_handler_D4:: ;
opcode_handler_D5:: ;
opcode_handler_D6:: ;
opcode_handler_D7:: ;
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
opcode_handler_F1:: ;
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