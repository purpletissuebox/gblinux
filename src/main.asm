SECTION "HEADER", ROM0[$0100]
nop
jp entry

ds $150-@, 0

SECTION "INIT", ROM0
entry:
halt
jr entry
