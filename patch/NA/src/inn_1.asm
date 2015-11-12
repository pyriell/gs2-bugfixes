; Suikoden II Inn Fix
; Written by Pyriel
;
; Prevents the Inn from healing your party without
; charge.

.psx
.align 4

.openfile YADOYA1.BIN, 0x8010DC50
.headersize 0
.org 0x8010E72C
	nop						; remove early call

; next section should be the save data menu, which processes as a Stay (potch subtracted) even if you cancel.
.org 0x8010F0F0
	jal		0x80074BAC      ; - with nop and call to HealParty
	nop						; move setting a0 for next func
	lw		$a0, 0x194($s2)
	addiu	$a1, $0, 8
	jal		0x8008B9D0

.close
