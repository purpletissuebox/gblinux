INCLUDE "macros.inc"

SECTION "WORD_OPS", ROM0
opcode_handler_40:: ;INC AX
opcode_handler_48:: ;DEC AX
opcode_handler_50:: ;PUSH AX
opcode_handler_58:: ;POP AX
	ld a, l
opcode_handler_41:: ;INC CX
opcode_handler_49:: ;DEC CX
opcode_handler_51:: ;PUSH CX
opcode_handler_59:: ;POP CX
	ld a, l
opcode_handler_42:: ;INC DX
opcode_handler_4A:: ;DEC DX
opcode_handler_52:: ;PUSH DX
opcode_handler_5A:: ;POP DX
	ld a, l
opcode_handler_43:: ;INC BX
opcode_handler_4B:: ;DEC BX
opcode_handler_53:: ;PUSH BX
opcode_handler_5B:: ;POP BX
	ld a, l
opcode_handler_44:: ;INC SP
opcode_handler_4C:: ;DEC SP
opcode_handler_54:: ;PUSH SP
opcode_handler_5C:: ;POP SP
	ld a, l
opcode_handler_45:: ;INC BP
opcode_handler_4D:: ;DEC BP
opcode_handler_55:: ;PUSH BP
opcode_handler_5D:: ;POP BP
	ld a, l
opcode_handler_46:: ;INC SI
opcode_handler_4E:: ;DEC SI
opcode_handler_56:: ;PUSH SI
opcode_handler_5E:: ;POP SI
	ld a, l
opcode_handler_47:: ;INC DI
opcode_handler_4F:: ;DEC DI
opcode_handler_57:: ;PUSH DI
opcode_handler_5F:: ;POP DI
	ld a, l
	sub LOW(opcode_handler_40)
	jp printReg16

SECTION "UNUSED", ROM0
opcode_handler_60:: ;UNUSED
	ld a, l
opcode_handler_61:: ;UNUSED
	ld a, l
opcode_handler_62:: ;UNUSED
	ld a, l
opcode_handler_63:: ;UNUSED
	ld a, l
opcode_handler_64:: ;UNUSED
	ld a, l
opcode_handler_65:: ;UNUSED
	ld a, l
opcode_handler_66:: ;UNUSED
	ld a, l
opcode_handler_67:: ;UNUSED
	ld a, l
opcode_handler_68:: ;UNUSED
	ld a, l
opcode_handler_69:: ;UNUSED
	ld a, l
opcode_handler_6A:: ;UNUSED
	ld a, l
opcode_handler_6B:: ;UNUSED
	ld a, l
opcode_handler_6C:: ;UNUSED
	ld a, l
opcode_handler_6D:: ;UNUSED
	ld a, l
opcode_handler_6E:: ;UNUSED
	ld a, l
opcode_handler_6F:: ;UNUSED
	printl "db "
	ld a, l
	sub (LOW(opcode_handler_60) - 0x60)
	jp printImm8_a

SECTION "JUMPS", ROM0
opcode_handler_70:: ;JO
opcode_handler_71:: ;JNO
opcode_handler_72:: ;JB
opcode_handler_73:: ;JNB
opcode_handler_74:: ;JZ
opcode_handler_75:: ;JNZ
opcode_handler_76:: ;JBE
opcode_handler_77:: ;JA
opcode_handler_78:: ;JS
opcode_handler_79:: ;JNS
opcode_handler_7A:: ;JPE
opcode_handler_7B:: ;JPO
opcode_handler_7C:: ;JL
opcode_handler_7D:: ;JGE
opcode_handler_7E:: ;JLE
opcode_handler_7F:: ;JG
	printl "@+"
	jp printImm8_bc