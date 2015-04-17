; Suikoden II After Battle Fixes
; Written by Pyriel
;
; Fixes the issues with bit flag checks for one time items.
; Recipes, Window Sets, Sound Sets, and Blueprints
;

.psx
.openfile BP0_AFT.BIN, 0x8002B000
.align 4

.org 0x8002D870
bookflags:					; the books are actually fine, just recreating
	li	v0, 1
	addiu	v1, s3, 0xFFFF
	sltiu	v0, v1, 0xC
	beqz	v0, blueprintflags
	addiu	a0, s3, 0xFFE5
	lhu	v0, 0x1F8(s4)
	nop
	srav	v0, v0, v1
	andi	v0, v0, 1
	bnez	v0, exit
	li	v0, 1
	addiu	a0, s3, 0xFFE5

.area 0x8002D8DC - 0x8002D8A0 			; check that the LI macro doesn't expand too far.
blueprintflags:
	sltiu	v0, a0, 0x10			; this section reorganizes the checks and changes
	beqz	v0, windowflags			; the logic to check a halfword field instead of byte
	sltiu	v0, a0, 8
	bne	v0, zero, load
	li	v1, 0
	sltiu	v0, a0, 0xC
	bne	v0, zero, load
	li	v1, 0xFFFFFFFC
	li	v1, 4
load:
	lhu	v0, 0x1FA(s4)
	subu	v1, a0, v1
	srav	v0, v0, v1
	andi	v0, v0, 1
	bnez	v0, exit
	li	v0, 1
.endarea
	
windowflags:
	addiu	v1, s3, 0xFFF3			; Window Sets evaluate the wrong address.
	sltiu	v0, v1, 7
	beqz	v0, soundflags
	addiu	a0, s3, 0xFFEC
	lbu	v0, 0x6E4(s4)
	nop
	srav	v0, v0, v1
	andi	v0, 1
	bnez	v0, exit
	li	v0, 1
	
soundflags:
	sltiu	v0, a0, 7			; Sound Sets too.
	beqz	v0, exit
	addu	v0, zero, zero
	lbu	v1, 0x6E5(s4)
	nop
	srav	v1, v1, a0
	andi	v1, v1, 1
	bnez	v1, exit
	li	v0, 1
	addu	v0, zero, zero
	
exit:
	lw	ra, 0x24(sp)			; preserved from old code

recipe_fix:
.org 0x8002D998					; fixing the Recipes by overlaying individual ops.
	addiu a1, v0, 0xFFD5
.org 0x8002D9E4					; more code than I wanted to copy.
	addu s0, s3, s4
.org 0x8002DA00
	srav v0, v0, s2
.org 0x8002DA34
	addiu a1, v0, 0xFFE0
.org 0x8002DA80
	addu s0, s3, s4
.org 0x8002DA9C
	srav v1, v1, s2

.close