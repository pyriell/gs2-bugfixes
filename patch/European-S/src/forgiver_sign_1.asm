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
; Note: Offset +0x48 from original NA file.
;


.psx
.align 4

.openfile BP0_FST.BIN, 0x8002B000
.headersize 0

.org 0x80044C28
.area 0x80044C2C-.

	li	$a3, 0			; let's set it to zero instead.

.endarea
.close
