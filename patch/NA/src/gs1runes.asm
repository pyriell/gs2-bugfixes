; Suikoden II Suikoden I Load - Rune Import
; Written by Pyriel
;
; For unknown reasons the Rune import is badly broken. So badly, it's difficult to tell what
; the original intent was.
;
; Rule 1: Character must have 3 empty rune slots.
; Rule 2: Character in GS1 must have a rune that can be converted.
; Rule X: After this, it gets muddy.  Various GS2 statuses that aren't set yet are checked.
;		  It appears the programmer either made a mistake, or reused functions were modified
;		  later, breaking the import.
;
; This patch changes the rules.  The character must have 1 empty Rune slot, and the slot
; must be unlocked at their current level.  If the rune can be converted, it will be attached.
 
.psx
.align 4

.openfile G1LOAD.BIN, 0x8010DC50
.headersize 0
.org 0x8010FB2C
.area 0x8010FB30-.
	beq		$0, $0, 0x8010FB70	;skip the three empty slots check
.endarea

;8010FC1C $s1 = counter (0), $s2 = rune digit
.org 0x8010FC1C
.area 0x8010FCB8-.

	lbu		$s0, 0($s4)			;hold character id
	ori		$a0, $0, 1
search:
	addiu 	$a1, $s1, 7
	addu	$a3, $0, $0
	jal		0x80071764			;get rune in slot $s1
	addu	$a2, $0, $s0
	bne		$v0, $0, next		;if equipped, try next one
	lui		$a3, 0x8007
	sll		$a0, $s0, 3			;get chara offset into growth array
	addu	$a0, $a0, $s0
	sll		$a0, $a0, 1			;got offset
	addu	$t0, $a3, $a0
	addu	$t0, $t0, $s1		;add slot
	lbu		$v0, 0x9202($t0) 	;slot unlock level
	sll		$v1, $s0, 3	
	addu	$v1, $v1, $s0
	sll		$v1, $v1, 2			;$v1 is offset into chara array
	addu	$t0, $a3, $v1		;$t0 is sort of base address for chara array
	lbu		$a2, 0x986E($t0) 	;chara level
	addu	$t0, $t0, $s1		;add rune offset
	sltu	$v0, $a2, $v0		;chara level < unlock level
	bne		$v0, $0, next
	nop
store:
	sb		$s2, 0x9883($t0)
	beq		$0, $0, quitrune
next:
	addiu	$s1, $s1, 1
	slti	$v0, $s1, 3
	bne		$v0, $0, search
	ori		$a0, $0, 1
	beq		$0, $0, quitrune
	nop
	
.endarea

.org 0x8010FCB8
.area 0x8010FCBC-.
quitrune:
	lw		$v0, 0xA7C($s7)
.endarea

.close