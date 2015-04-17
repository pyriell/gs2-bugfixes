; Suikoden II Badeaux Fix
; Written by Pyriel
;
; Badeaux never appears in the castle because the script never
; places his sprite on the map.  A second, correct script
; exists, but is never used.

.psx
.align 4

.openfile VK11.BIN, 0x8015DC50
.org 0x8015F708
	.halfword 0xF248		; change pointer to reference working script.
.close