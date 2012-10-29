; Suikoden II Unicorn Woods/Lamb Fix
; Written by Pyriel
;
; Fixes the issue with the lamb overlapping the first chest
; in Unicorn Woods.  Will probably include additional items later.
;
; Note: Offset +0xF7 from original NA file.

.psx
.openfile VH10.BIN, 0x8015DC50
.align 4

.org 0x80167819
.byte 0x40

.org 0x80167BA5
.byte 0x40
	
.close