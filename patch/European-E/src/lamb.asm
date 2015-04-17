; Suikoden II Unicorn Woods/Lamb Fix
; Written by Pyriel
;
; Fixes the issue with the lamb overlapping the first chest
; in Unicorn Woods.  Will probably include additional items later.
;
; Note: No changes from original NA file.

.psx
.openfile VH10.BIN, 0x8015DC50
.align 4

.org 0x8016771D
.byte 0x40

.org 0x80167AA9
.byte 0x40
	
.close