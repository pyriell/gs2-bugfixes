; Suikoden II Knife-Thrower (Eilie) Script Fix
; Written by Pyriel
;
; This is an attempt to correct the issue with the Eilie knife-throwing
; script that can result in your HP being 0 out of battle.
;
; The game hard-codes to chara 1 (Hero), so instead of using the function
; that halves any charas HP, this fix just halves it in the script.

.psx
.openfile VB18.BIN, 0x8010DC50
.org 0x8010DCA0
.align 4

eilie_fix:
	lui v1, 0x8007		
	lhu a0, 0x9896(v1)		;load hero's current HP
	addu s1, zero, v0		;preserved from previous code
	srl a0, a0, 1			;shift hit points right by 1 (divide by 2)
	bne a0, zero, store		;if hit points not zero, store
	nop
	addiu a0, zero, 1		;set to 1 if zero
	nop

store:
	sh a0, 0x9896(v1)

.close