; Suikoden II Gremio Text Fix
; Written by Pyriel
;
; In Banner Village during the McDohl side quest, Gremio has several
; lines of gibberish, if you try to leave via the boat while Ko is
; still in trouble.  For some reason, several dialog lines have no
; pointers.  The script goes to the location in the table that should
; contain them, but all that's there is text data from another string.
; When this is used as a pointer, it causes gibberish and, on real
; hardware, crashes, since the addresses will not be valid memory.
;
; Fix: Make a new table to replace the existing one.

.psx
.align 4

.openfile KIKORI.BIN, 0x8010DC50

.org 0x80112014
.area 0x80112090-.
TryPrizePlans:
	 jalr    $s2						; call rand()
	 nop
	 sll     $v1, $v0, 3				
	 subu    $v0, $v1, $v0
	 bgez    $v0, digitnz
	 sra     $s0, $v0, 15
	 addiu   $v0, 0x7FFF
	 sra     $s0, $v0, 15				; rand() % 7
digitnz:
	 bnez    $s0, 0x801120C8
	 li      $v0, 1
	 lui     $t0, 0x8007				
	 lbu	 $t0, 0xAA3B($t0)
	 addiu   $v0, $0, 0xFF00
	 andi	 $t0, $t0, 0x01
	 bnez    $t0, nextcheck
	 li      $v0, 1
	 and     $v1, $v0
	 li      $a1, 0xFFFF00FF
	 lbu     $v0, -0x2DF0($s6)
	 lbu     $a0, 1($s4)
	 or      $v1, $v0
	 and     $v1, $a1
	 sll     $a0, 8
	 or      $a0, $v1, $a0
	 jal     0x80111AC0
	 sll     $a0, 16
	 beqz    $v0, 0x801120C8
	 li      $v0, 1
nextcheck:
	 jalr    $s2
	 nop
.endarea

.close
