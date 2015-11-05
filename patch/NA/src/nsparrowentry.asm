; Suikoden II North Sparrow Escape Talisman/Entry Fix
; Written by Pyriel
;
; After returning from Highland with Nanami, there's a point where she
; can attempt to persuade the guards to let you through again and fail.
; Once she's failed, the guards should always tell you to buzz off when
; you get too close (keeping the pass blocked), but if you use an Escape
; Talisman just inside the pass, you can circumvent this.
;
; The Escape Talisman drops you in a different location than entering the
; pass normally, about 17 units east and 2 units north.  On entry, a script
; runs that sets a flag required for the guards to block you, but it checks
; only for the exact position you arrive at by entering from the world map.
; The Escape Talisman drops you elsewhere, so the flag isn't set, and the
; guards don't respond when you get close.
;
; Exploiting this bug allows you to return to Highland much earlier than you
; should.  Most things are still off limits.  You can't get to Sajah or anything
; for better runes.  However, you do get to see Kyaro as it will be near the
; end of the game.
;
; This script fixes the issue by moving the Escape Talisman destination closer
; to where you land when coming in from the world map, and expands the script
; check to encompass that area.

.psx
.openfile VB17.BIN, 0x8010DC50
.align 4

.org 0x8011466C
entry:
	.byte 0xAB
	.byte 1
	.byte 1
	.byte 6		;check that x-pos between 6--
	.byte 6		;--and 6
	.byte 2
	.byte 0x55	;check that y-pos between 0x55 (change from 0x57)--
	.byte 0x57	;--and 0x57


.org 0x801148EC
talisman:
	.byte 0
	.byte 0x6	;shift the talisman x-pos from 0x17
	.byte 0x55	;leave the y-pos

.close