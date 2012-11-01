; Suikoden II EXE Fix
; Written by Pyriel
;
; This file contains various fixes to the Suikoden II file:
; VA11.BIN
;
; Minotaur Name
; Magus Name
; Chimera Name
; Add Chimera Parties to Encounter Table
;
; Note: No offset, but name fixes not required.

.psx
.align 4

.openfile VA11.BIN, 0x8010DC50

;Add Chimera Parties to Encounter Table
.org 0x801363DC
.area 0x80136404-.
encounters:
	.word 0x801362DC, 0x80136384, 0x801362F8, 0x801363A0, 0x80136314, 0x80136330,
	.word 0x801363BC, 0x8013634C, 0x8013634C, 0x80136368
.endarea


.close