; Suikoden II Rune Speed Boost Fix
; Written by Pyriel
;
; When a character uses a Rune, the game stores the Rune slot number and the spell number used.
; This is later used to retrieve the actual rune from the character, and then the spell from the
; Rune.  The spell data includes "boost" flag that indicates whether or not an action should
; grant the character a temporary 30% speed boost (1.3x) to be used when determining turn order.
;
; When a character uses a Rune Unite, the game retains the Rune slot, but replaces the ordinal
; of the spell with the actual spell index of the Rune Unite.  When the game attempts to check
; the boost flag, it will try to retrieve spell number 50+ from the Rune.  Since no Rune has
; that many spells, the result is always data from something else, whether it's an item name,
; another Rune, etc.  If the byte retrieved happens to be the index of a spell that has a speed
; boost, or it leads to random data that has the 0x10 bit on, the character casting the Unite
; will receive a boost despite none of the Unite spells being eligible for it.
;
; This only has a minor effect on turn order.  It could cause a crash if the numbers were larger.
; Luckily, the error is limited to about 250 bytes of excess travel, so it can never attempt to
; read from kernel space or invalid addresses or anything of that nature.
;
; To fix the problem, the boost check can simply be abandoned if the spell ordinal is in a
; certain range.

.psx
.align 4

.openfile BP0_SEC.BIN, 0x8002B000
.headersize 0


; Magic
.org 0x8003E428
.area 0x8003E44C-.
	jalr	$v0
	lb      $s0, 0x51($s1)   ; Get spell # for rune -- being tricky here since $s0's value won't be needed again.
	nop						 ; Only really need filler, but this shuts the assembler up.
	sltiu	$a0, $s0, 0x36	 ; probably could be 4, but let's play it safe
	beqz    $a0, 0x8003E4E8
	addu	$v0, $s0         ; Add spell # to the offset into Rune data
	lbu     $a0, 0x38($v0)   ; Get spell ID?
	jal		0x80074784
	nop
.endarea
.close