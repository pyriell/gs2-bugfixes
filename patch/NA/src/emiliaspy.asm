; Suikoden II Inn Fix
; Written by Pyriel
;
; Prevents the Inn from healing your party without
; charge.

.psx
.align 4

.openfile VE07.BIN, 0x8010DC50
.headersize 0
.org 0x80119B0E
	.byte 0x4		; make Emilia use the hero's alias.

.close
