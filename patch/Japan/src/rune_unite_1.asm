; Suikoden II Rune Unite Fix
; Written by Pyriel
;
; The game initiates a search for each character not already marked as "united".
; When it discovers a compatible spell, it assigns the faster character the unite
; spell, and sets up the slower character to do nothing.
;
; For some bizarre reason, after a compatible spell is found, the search continues
; for the current character.  If more compatible spells are found, the unite
; assignment will occur again, and another character could have its actions
; cancelled.
;
; This bug presents itself in multiple ways, depending on the speed of the primary and secondary
; characters in the search/unite.
;
; To fix the problem, the search must be ended after a match is found.  This require shuffling
; some operations to make room.
;
; Note:  Offset +0x1E0 from original NA file.

.psx
.align 4

.openfile BP0_FST.BIN, 0x8002B000
.headersize 0


; Primary=Fire -- Secondary=Earth or Lightning
.org 0x8003F288
.area 0x8003F2D0-.

primFire:
	beqz    $a0, loc_8003F0EC	; exit if unite not found
	lhu     $v0, 0x34($s3)		; slid this up to replace a nop
	lhu     $v1, 0x34($s2)		; need an extra op for a new J to "next"
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F0D8
	nop
	sb      $s6, 0x4A($s3)
	sb      $a0, 0x49($s3)
	sb      $s1, 0x3F($s3)
	j       0x8003F6C8		; end search
	sb      $fp, 0x48($s2)
loc_8003F0D8:                            
	sb      $fp, 0x48($s3)
	sb      $s6, 0x4A($s2)
	sb      $a0, 0x49($s2)
	j	0x8003F6C8		; end search
	sb      $s4, 0x3F($s2)
loc_8003F0EC:
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003F0A8 - 0x8003F0F0






; Primary=Water -- Secondary=Wind or Lightning
; Changes identical to above

.org 0x8003F390
.area 0x8003F3D8-.

primWater:
	beqz    $a0, loc_8003F1EC
	lhu     $v0, 0x34($s3)
	lhu     $v1, 0x34($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F1D8
	nop
	sb      $s6, 0x4A($s3)
	sb      $a0, 0x49($s3)
	sb      $s1, 0x3F($s3)
	j       0x8003F6C8
	sb      $fp, 0x48($s2)
loc_8003F1D8:
	sb      $fp, 0x48($s3)
	sb      $s6, 0x4A($s2)
	sb      $a0, 0x49($s2)
	j       0x8003F6C8
	sb      $s4, 0x3F($s2)
loc_8003F1EC:
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003F1A8 - 0x8003F1F0






; Primary=Wind -- Secondary=Water or Earth
; Changes identical to above (less one SB here for some reason...)

.org 0x8003F48C
.area 0x8003F4CC-.

primWind:
	beqz    $a0, loc_8003F2D8
	lhu     $v0, 0x34($s3)
	lhu     $v1, 0x34($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F2C8
	nop
	sb      $a0, 0x49($s3)
	sb      $s1, 0x3F($s3)
	j       0x8003F6C8
	sb      $fp, 0x48($s2)
loc_8003F2C8:
	sb      $fp, 0x48($s3)
	sb      $a0, 0x49($s2)
	j       0x8003F6C8
	sb      $s4, 0x3F($s2)
loc_8003F2D8:
	lbu     $v0, 0x340($s5)
	
.endarea ; 0x8003F29C - 0x8003F2D8






; Primary=Earth -- Secondary=Fire or Wind
; Changes identical to above (less one SB here for some reason...)

.org 0x8003F578
.area 0x8003F5B8-.

primEarth:
	beqz    $a0, loc_8003F3BC
	lhu     $v0, 0x34($s3)
	lhu     $v1, 0x34($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F3AC
	nop
	sb      $a0, 0x49($s3)
	sb      $s1, 0x3F($s3)
	j       0x8003F6C8
	sb      $fp, 0x48($s2)
loc_8003F3AC:
	sb      $fp, 0x48($s3)
	sb      $a0, 0x49($s2)
	j       0x8003F6C8
	sb      $s4, 0x3F($s2)
loc_8003F3BC:
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003F380 - 0x8003F3BC







; Primary=Lightning -- Secondary=Fire or Water
; Changes identical to above 

.org 0x8003F670
.area 0x8003F6B8-.

primLightning:
	beqz    $a0, loc_8003F4B4
	lhu     $v0, 0x34($s3)
	lhu     $v1, 0x34($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F4A0
	nop
	sb      $s6, 0x4A($s3)
	sb      $a0, 0x49($s3)
	sb      $s1, 0x3F($s3)
	j       0x8003F6C8
	sb      $fp, 0x48($s2)
loc_8003F4A0:
	sb      $fp, 0x48($s3)
	sb      $a0, 0x49($s2)
	sb      $s6, 0x4A($s2)
	j       0x8003F6C8
	sb      $s4, 0x3F($s2)
loc_8003F4B4: 
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003F470 - 0x8003F4B4
.close
