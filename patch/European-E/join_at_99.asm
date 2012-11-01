; Suikoden II Recruit at 99 Fix
; Written by Pyriel
;
; Fix the casting issue that causes some characters to join
; at level 99, when they should be at Hero +/- a few levels.
;
; Note: Offset 0x40 from original NA file.

.psx
.align 4

.openfile SLUS_024.42, 0x8006A800

;Recruit at 99 Glitch
.org 0x800A241C
ninetynine:
	lbu v0, 0x10(sp)			; replaces lw operation
.org 0x800A2428
	lbu v0, 0x10(sp)
	
.close