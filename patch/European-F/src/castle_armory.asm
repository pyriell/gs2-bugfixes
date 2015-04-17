; Suikoden II Castle Armory Fix 
; Written by Pyriel
;
; This is an attempt to correct the issue with the castle armory
; allowing you to buy items you can't afford at one point in its
; menus, which results in your potch falling below zero and being
; reset to an enormous value.

.psx
.align 4

.openfile HDOUGUYA.BIN, 0x8010DC50
.org 0x80113CD0
	addiu $v0, $v0, 0x0E48
.close