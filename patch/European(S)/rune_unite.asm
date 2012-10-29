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
; Note:  Offset +0x48 from original NA file.

.psx
.align 4

.openfile BP0_FST.BIN, 0x8002B000
.headersize 0


; Primary=Fire -- Secondary=Earth or Lightning
.org 0x8003F0F0
.area 0x8003F138-.

primFire:
	beqz    $a0, loc_8003F0EC	; exit if unite not found
	lhu     $v0, 0x3A($s3)		; slid this up to replace a nop
	lhu     $v1, 0x3A($s2)		; need an extra op for a new J to "next"
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F0D8
	nop
	sb      $s6, 0x52($s3)
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003F510		; end search
	sb      $fp, 0x50($s2)
loc_8003F0D8:                            
	sb      $fp, 0x50($s3)
	sb      $s6, 0x52($s2)
	sb      $a0, 0x51($s2)
	j	0x8003F510		; end search
	sb      $s4, 0x45($s2)
loc_8003F0EC:
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003F0A8 - 0x8003F0F0






; Primary=Water -- Secondary=Wind or Lightning
; Changes identical to above

.org 0x8003F1F0
.area 0x8003F238-.

primWater:
	beqz    $a0, loc_8003F1EC
	lhu     $v0, 0x3A($s3)
	lhu     $v1, 0x3A($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F1D8
	nop
	sb      $s6, 0x52($s3)
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003F510
	sb      $fp, 0x50($s2)
loc_8003F1D8:
	sb      $fp, 0x50($s3)
	sb      $s6, 0x52($s2)
	sb      $a0, 0x51($s2)
	j       0x8003F510
	sb      $s4, 0x45($s2)
loc_8003F1EC:
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003F1A8 - 0x8003F1F0






; Primary=Wind -- Secondary=Water or Earth
; Changes identical to above (less one SB here for some reason...)

.org 0x8003F2E4
.area 0x8003F324-.

primWind:
	beqz    $a0, loc_8003F2D8
	lhu     $v0, 0x3A($s3)
	lhu     $v1, 0x3A($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F2C8
	nop
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003F510
	sb      $fp, 0x50($s2)
loc_8003F2C8:
	sb      $fp, 0x50($s3)
	sb      $a0, 0x51($s2)
	j       0x8003F510
	sb      $s4, 0x45($s2)
loc_8003F2D8:
	lbu     $v0, 0x340($s5)
	
.endarea ; 0x8003F29C - 0x8003F2D8






; Primary=Earth -- Secondary=Fire or Wind
; Changes identical to above (less one SB here for some reason...)

.org 0x8003F3C8
.area 0x8003F408-.

primEarth:
	beqz    $a0, loc_8003F3BC
	lhu     $v0, 0x3A($s3)
	lhu     $v1, 0x3A($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F3AC
	nop
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003F510
	sb      $fp, 0x50($s2)
loc_8003F3AC:
	sb      $fp, 0x50($s3)
	sb      $a0, 0x51($s2)
	j       0x8003F510
	sb      $s4, 0x45($s2)
loc_8003F3BC:
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003F380 - 0x8003F3BC







; Primary=Lightning -- Secondary=Fire or Water
; Changes identical to above 

.org 0x8003F4B8
.area 0x8003F500-.

primLightning:
	beqz    $a0, loc_8003F4B4
	lhu     $v0, 0x3A($s3)
	lhu     $v1, 0x3A($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003F4A0
	nop
	sb      $s6, 0x52($s3)
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003F510
	sb      $fp, 0x50($s2)
loc_8003F4A0:
	sb      $fp, 0x50($s3)
	sb      $a0, 0x51($s2)
	sb      $s6, 0x52($s2)
	j       0x8003F510
	sb      $s4, 0x45($s2)
loc_8003F4B4: 
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003F470 - 0x8003F4B4
.close





;###################### Begin Second File ###################


.openfile BP0_SEC.BIN, 0x8002B000
.headersize 0


; Primary=Fire -- Secondary=Earth or Lightning
.org 0x8003E8A8
.area 0x8003E8F0-.

primFire2:
	beqz    $a0, loc_8003E8A4	; exit if unite not found
	lhu     $v0, 0x3A($s3)		; slid this up to replace a nop
	lhu     $v1, 0x3A($s2)		; need an extra op for a new J to "next"
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003E890
	nop
	sb      $s6, 0x52($s3)
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003ECC8		; end search
	sb      $fp, 0x50($s2)
loc_8003E890:                            
	sb      $fp, 0x50($s3)
	sb      $s6, 0x52($s2)
	sb      $a0, 0x51($s2)
	j	0x8003ECC8		; end search
	sb      $s4, 0x45($s2)
loc_8003E8A4:
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003E860 - 0x8003E8A8






; Primary=Water -- Secondary=Wind or Lightning
; Changes identical to above

.org 0x8003E9A8
.area 0x8003E9F0-.

primWater2:
	beqz    $a0, loc_8003E9A4
	lhu     $v0, 0x3A($s3)
	lhu     $v1, 0x3A($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003E990
	nop
	sb      $s6, 0x52($s3)
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003ECC8
	sb      $fp, 0x50($s2)
loc_8003E990:
	sb      $fp, 0x50($s3)
	sb      $s6, 0x52($s2)
	sb      $a0, 0x51($s2)
	j       0x8003ECC8
	sb      $s4, 0x45($s2)
loc_8003E9A4:
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003E960 - 0x8003E9A8






; Primary=Wind -- Secondary=Water or Earth
; Changes identical to above (less one SB here for some reason...)

.org 0x8003EA9C
.area 0x8003EADC-.

primWind2:
	beqz    $a0, loc_8003EA90
	lhu     $v0, 0x3A($s3)
	lhu     $v1, 0x3A($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003EA80
	nop
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003ECC8
	sb      $fp, 0x50($s2)
loc_8003EA80:
	sb      $fp, 0x50($s3)
	sb      $a0, 0x51($s2)
	j       0x8003ECC8
	sb      $s4, 0x45($s2)
loc_8003EA90:
	lbu     $v0, 0x340($s5)
	
.endarea ; 0x8003F29C - 0x8003F2D8






; Primary=Earth -- Secondary=Fire or Wind
; Changes identical to above (less one SB here for some reason...)

.org 0x8003EB80
.area 0x8003EBC0-.

primEarth2:
	beqz    $a0, loc_8003EB74
	lhu     $v0, 0x3A($s3)
	lhu     $v1, 0x3A($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003EB64
	nop
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003ECC8
	sb      $fp, 0x50($s2)
loc_8003EB64:
	sb      $fp, 0x50($s3)
	sb      $a0, 0x51($s2)
	j       0x8003ECC8
	sb      $s4, 0x45($s2)
loc_8003EB74:
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003EB38 - 0x8003EB78







; Primary=Lightning -- Secondary=Fire or Water
; Changes identical to above 

.org 0x8003EC70
.area 0x8003ECB8-.

primLightning2:
	beqz    $a0, loc_8003EC6C
	lhu     $v0, 0x3A($s3)
	lhu     $v1, 0x3A($s2)
	nop
	sltu    $v0, $v1
	bnez    $v0, loc_8003EC58
	nop
	sb      $s6, 0x52($s3)
	sb      $a0, 0x51($s3)
	sb      $s1, 0x45($s3)
	j       0x8003ECC8
	sb      $fp, 0x50($s2)
loc_8003EC58:
	sb      $fp, 0x50($s3)
	sb      $a0, 0x51($s2)
	sb      $s6, 0x52($s2)
	j       0x8003ECC8
	sb      $s4, 0x45($s2)
loc_8003EC6C: 
	lbu     $v0, 0x340($s5)

.endarea ; 0x8003EC28 - 0x8003EC70
.close