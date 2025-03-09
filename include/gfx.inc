MACRO GFXTASK
dw (\1 + \2) | (BANK(\1) & 0x07)
db BANK(\1)
dw (\3 + \4) | BANK(\3)
IF _NARG > 4
	db (\5) - 1
ELSE
	db ((\1.end - \1) >> 4) - 1
ENDC
ENDM
