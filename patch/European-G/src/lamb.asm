; Suikoden II Unicorn Woods/Lamb Fix
; Written by Pyriel
;
; Fixes the issue with the lamb overlapping the first chest
; in Unicorn Woods.  Will probably include additional items later.
;
; Note: Offset +0xD8 from original NA file.

.psx
.openfile VH10.BIN, 0x8015DC50
.align 4

.org 0x801677F5
.byte 0x40

.org 0x80167B81
.byte 0x40
	
.close