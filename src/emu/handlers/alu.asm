INCLUDE "macros.inc"

SECTION "ALU_B_RM_REG", ROM0
opcode_handler_00:: ;ADD.b r/m, reg
opcode_handler_08:: ; OR.b r/m, reg
opcode_handler_10:: ;ADC.b r/m, reg
opcode_handler_18:: ;SBB.b r/m, reg
opcode_handler_20:: ;AND.b r/m, reg
opcode_handler_28:: ;SUB.b r/m, reg
opcode_handler_30:: ;XOR.b r/m, reg
opcode_handler_38:: ;CMP.b r/m, reg
	ld a, [bc]
	push af
	call printR2_8_bc
	printl ", "
	pop af
	jp printR1_8_a

SECTION "ALU_W_RM_REG", ROM0
opcode_handler_01:: ;ADD.w r/m, reg
opcode_handler_09:: ; OR.w r/m, reg
opcode_handler_11:: ;ADC.w r/m, reg
opcode_handler_19:: ;SBB.w r/m, reg
opcode_handler_21:: ;AND.w r/m, reg
opcode_handler_29:: ;SUB.w r/m, reg
opcode_handler_31:: ;XOR.w r/m, reg
opcode_handler_39:: ;CMP.w r/m, reg
	ld a, [bc]
	push af
	call printR2_16_bc
	printl ", "
	pop af
	jp printR1_16_a

SECTION "ALU_B_REG_RM", ROM0
opcode_handler_02:: ;ADD.b reg, r/m
opcode_handler_0A:: ; OR.b reg, r/m
opcode_handler_12:: ;ADC.b reg, r/m
opcode_handler_1A:: ;SBB.b reg, r/m
opcode_handler_22:: ;AND.b reg, r/m
opcode_handler_2A:: ;SUB.b reg, r/m
opcode_handler_32:: ;XOR.b reg, r/m
opcode_handler_3A:: ;CMP.b reg, r/m
	call printR1_8_bc
	printl ", "
	jp printR2_8_bc

SECTION "ALU_W_REG_RM", ROM0
opcode_handler_03:: ;ADD.w reg, r/m
opcode_handler_0B:: ; OR.w reg, r/m
opcode_handler_13:: ;ADC.w reg, r/m
opcode_handler_1B:: ;SBB.w reg, r/m
opcode_handler_23:: ;AND.w reg, r/m
opcode_handler_2B:: ;SUB.w reg, r/m
opcode_handler_33:: ;XOR.w reg, r/m
opcode_handler_3B:: ;CMP.w reg, r/m
	call printR1_16_bc
	printl ", "
	jp printR2_16_bc

SECTION "ALU_B_ACC_IMM", ROM0
opcode_handler_04:: ;ADD.b AL, imm
opcode_handler_0C:: ; OR.b AL, imm
opcode_handler_14:: ;ADC.b AL, imm
opcode_handler_1C:: ;SBB.b AL, imm
opcode_handler_24:: ;AND.b AL, imm
opcode_handler_2C:: ;SUB.b AL, imm
opcode_handler_34:: ;XOR.b AL, imm
opcode_handler_3C:: ;CMP.b AL, imm
	printl "AL, "
	jp printImm8_bc

SECTION "ALU_W_ACC_IMM", ROM0
opcode_handler_05:: ;ADD.w AX, imm
opcode_handler_0D:: ; OR.w AX, imm
opcode_handler_15:: ;ADC.w AX, imm
opcode_handler_1D:: ;SBB.w AX, imm
opcode_handler_25:: ;AND.w AX, imm
opcode_handler_2D:: ;SUB.w AX, imm
opcode_handler_35:: ;XOR.w AX, imm
opcode_handler_3D:: ;CMP.w AX, imm
	printl "AX, "
	jp printImm16_bc

SECTION "SEGMENT_STACK", ROM0
opcode_handler_06:: ;PUSH ES
opcode_handler_07:: ;POP ES
	ld a, l
opcode_handler_0E:: ;PUSH CS
opcode_handler_0F:: ;POP CS
	ld a, l
opcode_handler_16:: ;PUSH SS
opcode_handler_17:: ;POP SS
	ld a, l
opcode_handler_1E:: ;PUSH DS
opcode_handler_1F:: ;POP DS
	ld a, l
	sub LOW(opcode_handler_06)
	jp printSegment

SECTION "SEG_OVERRIDE", ROM0
opcode_handler_26:: ;ES:
	ld a, l
opcode_handler_2E:: ;CS:
	ld a, l
opcode_handler_36:: ;SS:
	ld a, l
opcode_handler_3E:: ;DS:
	ld a, l
	sub LOW(opcode_handler_26)
	call printSegment
	printl ":"
	jp disOneInstruction

SECTION "ACC_ADJUST", ROM0
opcode_handler_27:: ;DAA
opcode_handler_2F:: ;DAS
opcode_handler_37:: ;AAA
opcode_handler_3F:: ;AAS
	ret
