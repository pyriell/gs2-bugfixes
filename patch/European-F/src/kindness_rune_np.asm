; Suikoden II Kindness Rune Fix
; Written by Pyriel
;
; Fix the Kindness Rune Overflow Glitch
; This version causes no penalties.  There is just no bonus until
; the rating is greater than zero.

.psx
.align 4

.openfile SLUS_009.58, 0x8006A800

;Kindness Rune Glitch
.org 0x80088960
kindness:
	bltz s2, 0x8008896C
	addu v1, v0, v1
	addu v1, v1, s2

.close