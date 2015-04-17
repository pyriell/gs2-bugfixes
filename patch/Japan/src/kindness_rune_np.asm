; Suikoden II Kindness Rune Fix
; Written by Pyriel
;
; Fix the Kindness Rune Overflow Glitch
; This version causes no penalties.  There is just no bonus until
; the rating is greater than zero.
;
; Note: Offset -0x3C from original NA file.

.psx
.align 4

.openfile SLPM_861.68, 0x8006A800

;Kindness Rune Glitch
.org 0x80088934
kindness:
	bltz s2, 0x80088940
	addu v1, v0, v1
	addu v1, v1, s2

.close