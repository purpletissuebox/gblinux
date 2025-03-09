INCLUDE "hwregs.inc"
INCLUDE "macros.inc"
INCLUDE "common/vblank.inc"

SECTION "GFX ROUTINES", ROM0
queueGfxTask::
	swapRamBank gfx_task_queue
	ld h, HIGH(gfx_task_queue)
	ld a, [gfx_task_tail]
	ld l, a ;hl points to empty slot
	REPT 6
		ld a, [de]
		inc de
		ldi [hl], a
	ENDR
	ld a, l
	cp LOW(gfx_task_queue + 2 + 6*10)
	jr c, queueGfxTask.savePtr
		ld a, LOW(gfx_task_tail)
	.savePtr:
	ld [gfx_task_tail], a
	ldh a, [redraw_screen]
	or RELOAD_GFX_TASK
	ldh [redraw_screen], a
	restoreRamBank
	ret
