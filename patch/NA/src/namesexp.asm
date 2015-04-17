; Suikoden II Names Expansion Patch
; Written by Pyriel
;
;

.psx
.align 4

.openfile BOOT.BIN, 0x8015DC50
.headersize 0
.org 0x8015F554
.area 0x8015F570-.

  lui     $a0, 0x8018  		;Fragment loads the character names from NAMES.BIN to 0x80068918.
  ori     $a0, $a0, 0x4E0C
  lui     $a1, 0x801E		;Change target address...
  addiu   $s0, 1
  sw      $s2, 0x626C($s3)
  jalr    $s2              	
  addiu   $a1, 0x1000		;...To 0x801AD05C 
.endarea
.close

.openfile SLUS_009.58, 0x8006A800
.org 0x80072FB4
.area 0x80072FC8-.
  lui	  $v0, 0x801E		;Change names address...
  sll	  $v1, $a0, 4
  addu	  $v1, $v1, $a0
  nop
  addiu   $v1, $v1, 0x1000	;...To 0x801AD05C
.endarea
.close
