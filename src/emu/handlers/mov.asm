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
	jp printR2_8_bc

SECTION "ATOMIC_OPS_W", ROM0
opcode_handler_85:: ;TEST.w reg, r/m
opcode_handler_87:: ;XCHG.w reg, r/m
opcode_handler_8B:: ; MOV.w reg, r/m
opcode_handler_8D:: ; LEA.w reg, r/m
	call printR1_16_bc
	printl ", "
	jp printR2_16_bc

SECTION "EXTRA_MOVS", ROM0
opcode_handler_88:: ;MOV.b r/m, reg
	ld a, [bc]
	push af
	call printR2_8_bc
	printl ", "
	pop af
	jp printR1_8_a
opcode_handler_89:: ;MOV.w r/m, reg
	ld a, [bc]
	push af
	call printR2_16_bc
	printl ", "
	pop af
	jp printR1_16_a

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
	ret

SECTION "SIGN_EXTEND", ROM0
opcode_handler_98:: ;CBW AL, AH
	printl "AL, AH"
	ret
opcode_handler_99:: ;CWD DX, AX
	printl "AX, DX"
	ret

SECTION "FAR_CALL", ROM0
opcode_handler_9A:: ;CALL far
	call printImm16_bc
	printl ":"
	jp printImm16_bc

SECTION "IDEK", ROM0
opcode_handler_9B:: ;WAIT
opcode_handler_9C:: ;PUSHF
opcode_handler_9D:: ;POPF
opcode_handler_9E:: ;SAHF
opcode_handler_9F:: ;LAHF
opcode_handler_A4:: ;MOVSB
opcode_handler_A5:: ;MOVSW
opcode_handler_A6:: ;CMPSB
opcode_handler_A7:: ;CMPSW
opcode_handler_AA:: ;STOSB
opcode_handler_AB:: ;STOSW
opcode_handler_AC:: ;LODSB
opcode_handler_AD:: ;LODSW
opcode_handler_AE:: ;SCASB
opcode_handler_AF:: ;SCASW
	RET

SECTION "MOV_ACC_MEM", ROM0
opcode_handler_A0:: ;MOV AL, addr
	printl "AL, ["
	call printImm16_bc
	printl "]"
	ret
opcode_handler_A1:: ;MOV AX, addr
	printl "AX, ["
	call printImm16_bc
	printl "]"
	ret
opcode_handler_A2:: ;MOV addr, AL
	printl "["
	call printImm16_bc
	printl "], AL"
	ret
opcode_handler_A3:: ;MOV addr, AX
	printl "["
	call printImm16_bc
	printl "], AX"
	ret
opcode_handler_A8:: ;TEST AL, imm
	printl "AL, "
	jp printImm8_bc
opcode_handler_A9:: ;TEST AX, imm
	printl "AX, "
	jp printImm16_bc

SECTION "MOV_REG8_IMM", ROM0
opcode_handler_B0:: ;MOV AL, imm
	ld a, l
opcode_handler_B1:: ;MOV CL, imm
	ld a, l
opcode_handler_B2:: ;MOV DL, imm
	ld a, l
opcode_handler_B3:: ;MOV BL, imm
	ld a, l
opcode_handler_B4:: ;MOV AH, imm
	ld a, l
opcode_handler_B5:: ;MOV CH, imm
	ld a, l
opcode_handler_B6:: ;MOV DH, imm
	ld a, l
opcode_handler_B7:: ;MOV BH, imm
	ld a, l
	sub LOW(opcode_handler_B0)
	call printReg8
	printl ", "
	jp printImm8_bc

opcode_handler_B8:: ;MOV AX, imm
	ld a, l
opcode_handler_B9:: ;MOV CX, imm
	ld a, l
opcode_handler_BA:: ;MOV DX, imm
	ld a, l
opcode_handler_BB:: ;MOV BX, imm
	ld a, l
opcode_handler_BC:: ;MOV SP, imm
	ld a, l
opcode_handler_BD:: ;MOV BP, imm
	ld a, l
opcode_handler_BE:: ;MOV SI, imm
	ld a, l
opcode_handler_BF:: ;MOV DI, imm
	ld a, l
	sub LOW(opcode_handler_B8)
	call printReg16
	printl ", "
	jp printImm16_bc
