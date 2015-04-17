; Suikoden II Suikoden I Load Fix
; Written by Pyriel
;
; Fixes the copying of the hero and castle names from the
; original game.
; This fix eliminates a check for a null pointer.  There
; are three calls to this in the entire game, and they
; all pass hard-coded, non-null pointers, so it should be safe.

.psx
.align 4

.openfile G1LOAD.BIN, 0x8010DC50
.headersize 0
.org 0x80110E0C
.area 0x80110E7C-.

strcpyS1S2:
	addu	a3, zero, zero
checkchar:
	addu	v0, a0, a3			; have to eliminate check for null pointer
	lbu	v1, 0(v0)
	addiu	a3, a3, 1
	beq	v1, zero, store			; null
	addu	v0, zero, v1
	addiu	t0, v1, 0xFFF0			; lowercase (and space)
	sltiu	t0, t0, 0x1B
	bne	t0, zero, store
	addiu	t0, v1, 0xFFD5			; uppercase
	sltiu	t0, t0, 0x1A
	bne	t0, zero, store
	addiu	v0, v1, 0x10
	addiu	t0, v1, 0xFFBB			; 0-9 :;"''&,.!?()+
	sltiu	t0, t0, 0x13
	bne	t0, zero, store
	addiu 	v0, v1, 0x53
	addiu	t0, v1, 0xFFA8			; brackets and buttons
	sltiu	t0, t0, 0x15
	bne	t0, zero, next
	addiu	v0, v1, 0x10
store:
	sb	v0, 0(a1)
next:
	slt	v0, a3, a2
	bne	v0, zero, checkchar
	addiu	a1, a1, 1
	jr	ra
	nop
.endarea
.close