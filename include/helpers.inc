MACRO call_banked
	ld b, BANK(\1)
	ld hl, \1
	call banked
ENDM
