; Suikoden II Inn Fix
; Written by Pyriel
;
; Prevents the Inn from healing your party without
; charge.

.psx
.align 4

.openfile YADOYA1.BIN, 0x8010DC50
.headersize 0
.org 0x8010E72C

	nop

.close
