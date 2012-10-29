; Suikoden II Kindness Rune Fix.
; Written by Pyriel
;
; Fix the Kindness Rune Overflow Glitch
; This version allows a penalty to occur when the Kindness Rating
; is less than zero.  I believe that this was Konami's intention
; based on the fact that the Kindness Rating can become negative.
; It's impossible to be certain, since the mistake is treating
; the Rating as though it is an unsigned 16-bit number.
;
; Note: Offset -0x3C from original NA file.

.psx
.align 4

.openfile SLPM_861.68, 0x8006A800

;Kindness Rune Glitch
.org 0x80088938
kindness:
	addu v1, s2, zero			; replaces andi v1, s2, 0xFFFF

.close