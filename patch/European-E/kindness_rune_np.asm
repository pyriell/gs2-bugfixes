; Suikoden II Kindness Rune Fix
; Written by Pyriel
;
; Fix the Kindness Rune Overflow Glitch
; This version causes no penalties.  There is just no bonus until
; the rating is greater than zero.
;
; Note: Offset 0xA0 from original NA file.

.psx
.align 4

.openfile SLES_024.42, 0x8006A800

;Kindness Rune Glitch
.org 0x80088A10
kindness:
	bltz s2, 0x80088A1C
	addu v1, v0, v1
	addu v1, v1, s2

.close