SECTION FRAGMENT "GFX_VARS", WRAMX, ALIGN[10]
	shadow_bkg_map::
		ds 0x0400
	shadow_win_map::
		ds 0x0400
ENDSECTION

SECTION FRAGMENT "GFX_VARS", WRAMX, ALIGN[8]
	shadow_oam::
		ds 0xA0
	.end::
ENDSECTION

SECTION FRAGMENT "GFX_VARS", WRAMX
	shadow_scroll_y::
		ds 0x01
	shadow_scroll_x::
		ds 0x01
	shadow_win_y::
		ds 0x01
	shadow_win_x::
		ds 0x01
ENDSECTION

SECTION FRAGMENT "GFX_VARS", WRAMX
	shadow_palettes_bkg::
		ds 8*4*2
	.end::
	shadow_palettes_obj::
		ds 8*4*2
	.end::
ENDSECTION

SECTION "HRAM", HRAM
	rom_bank::
		ds 0x01
	ram_bank::
		ds 0x01
	vram_bank::
		ds 0x01
	redraw_screen::
		ds 0x01