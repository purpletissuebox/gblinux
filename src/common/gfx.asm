INCLUDE "hwregs.inc"
INCLUDE "macros.inc"
INCLUDE "common/vblank.inc"

SECTION "GFX ROUTINES", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;submit a "graphics task" for processing later this frame.
;maintain a fifo queue of graphics tasks and flag vblank handler to run them
;inputs: de = ptr to task
;outputs: de = ptr to start of next task, bc unchanged
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
queueGfxTask::
	swapRamBank gfx_task_queue
	ld hl, gfx_task_head
	ld l, [hl] ;hl points to next empty slot
	REPT 6
		ld a, [de]
		inc de
		ldi [hl], a ;copy task into queue
	ENDR
	
	;get pointer to the next empty slot, which may be the beginning
	ld a, l
	add 0x02
	xor l
	and 0x3F
	xor l ;bit trick - A wraps around in a 64-byte space
	ld [gfx_task_head], a ;mark this space as next up
	
	ldh a, [redraw_screen]
	or RELOAD_GFX_TASK
	ldh [redraw_screen], a ;flag gfx task for vblank processing
	restoreRamBank
	ret
