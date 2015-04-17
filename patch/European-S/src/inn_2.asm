; Suikoden II Inn Fix
; Written by Pyriel
;
; Prevents the Inn from healing your party without
; charge.
;
; Note:  No change from original NA file.

.psx
.align 4

.openfile YADOYA2.BIN, 0x8015DC50
.headersize 0
.org 0x8015E72C

	nop

.close