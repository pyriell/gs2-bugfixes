; Suikoden II Recruit at 99 Fix
; Written by Pyriel
;
; Fix the casting issue that causes some characters to join
; at level 99, when they should be at Hero +/- a few levels.
;
; Note: Offset +0x258 from original NA file.

.psx
.align 4

.openfile SLPM_861.68, 0x8006A800

;Recruit at 99 Glitch
.org 0x800A25D4
ninetynine:
	lbu v0, 0x10(sp)			; replaces lw operation
.org 0x800A25E0
	lbu v0, 0x10(sp)
	
.close