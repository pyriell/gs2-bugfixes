; Suikoden II Forgiver Sign Fix
; Written by Pyriel
;
; When your party needs more than 2,000 HP of healing, there is nothing
; left over to damage the targetted enemy.  The result should be 0 damage
; and it is, but the game incorrectly displays a huge amount of damage done.
; It actually flags the "out of HP" condition by setting the damage to -1
; HP.  This causes the routine that applies damage to be bypassed (no damage),
; but the pop-up on screen has to have some value. I believe it grabs junk
; data.
;


.psx
.align 4

;###################### Begin Second File ###################

.openfile BP0_SEC.BIN, 0x8002B000
.headersize 0

.org 0x800443A0
.area 0x800443A4-.

	li	$a3, 0			; let's set it to zero instead.

.endarea
.close