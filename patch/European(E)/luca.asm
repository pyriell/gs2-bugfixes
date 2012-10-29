; Suikoden II Luca Bug/Party Change Fix
; Written by Pyriel
;
;
; Note:  Offset +0x8 from original NA file.

.psx
.align 4

; all the $s registers are pretty much fair game.
; Using $v1 for address (already loaded).

.openfile PARTYCE1.BIN, 0x8010DC50
.headersize 0
.org 0x80110C28

.area 0x80110C88-.
; replace loop that empties party
loop:
	jalr    $s1
	move    $a0, $s0
	beqz    $v0, continue
	nop
	jalr    $s1
	move    $a0, $s0
	li      $v1, 1
	beq     $v0, $v1, continue
	move    $a0, $s0
	jalr    $s1
	nop
	li      $a0, 0x26
	jalr    $s5
	move    $a1, $v0
	move    $a0, $s0
	jalr    $s3				; RemoveFromParty After this, it should call 0x80073894 - ReformPartyOnExit
	nop
continue:
	addiu   $s0, 1
	slti    $v0, $s0, 6
	bnez    $v0, loop
	nop
	jal 	0x80073894			; Same address in SLES as SLUS.
	nop
	li	$a0, 0x25
.endarea
.close