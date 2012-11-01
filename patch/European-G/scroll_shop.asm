.psx
.align 4

.openfile FUDAZUK.BIN, 0x8010DC50
.headersize 0

.org 0x8011147C
.area 0x8011150C-.

	li      $s7, 0x8008DF10
	li      $s6, 0x80088D4C		; replace sub 0x80070348
	li      $s5, 0x8008D758
	li      $fp, 1
	li      $s4, 0x8008E3EC
	lbu     $v1, 0x17($s2)
	nop
	addiu   $v1, 1
	sll     $v0, $v1, 3
	subu    $v0, $v1
	slt     $v0, $s0, $v0
	beqz    $v0, 0x80111568
	move    $a1, $0
	lw      $a0, 0x1C4($s2)
	move    $a2, $s1
	jalr    $s7
	sw      $s7, -0x874($s3)
	li      $v1, 0x80061000
	li      $a0, 0x80114A7C
	sll     $v0, $s0, 1
	addu    $v0, $v1
	li      $v1, 0x8000
	addu    $v0, $v1
	sw      $s6, -0x874($s3)
	lbu     $a0, 0x14AF($v0)	; $a0 is type/quantity
	lbu     $a1, 0x14AE($v0)	; $a1 is item
	nop				; no longer need or want the andi
	jalr    $s6
	nop				; or the srl that isolated the type bits
	move    $a1, $v0

.endarea

.org 0x80111E5C
.area 0x80111EDC-.

	li      $t0, 0x8008DF10
	sw      $t0, 0x20($sp)
	li      $fp, 0x80088D4C		; replace sub 0x80070348
	li      $s7, 0x8008D758
	li      $s6, 0x8008E3EC
	lbu     $v0, 0x16($s2)
	nop
	beq     $s0, $v0, 0x80111F48
	move    $a1, $0
	andi    $s1, $s5, 0xFF
	lw      $a0, 0x1C4($s2)
	lw      $t0, 0x20($sp)
	move    $a2, $s1
	jalr    $t0
	sw      $t0, -0x874($s4)
	li      $v1, 0x80069000
	li      $a0, 0x80114A7C
	sll     $v0, $s0, 1
	or      $v0, $v1
	sw      $fp, -0x874($s4)
	lbu     $a0, 0x14AF($v0)	; $a0 is type/quantity
	lbu     $a1, 0x14AE($v0)	; $a1 is item
	nop				; no longer need or want the andi
	jalr    $fp
	nop				; or the srl that isolated the type bits
	move    $a1, $v0

.endarea

.close