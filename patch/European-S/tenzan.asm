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
.org 0x801363D4
.area 0x801363FC-.
encounters:
	.word 0x80136484, 0x8013652C, 0x801364A0, 0x80136548, 0x801364BC, 0x801364D8,
	.word 0x80136564, 0x801364F4, 0x801364F4, 0x80136510
.endarea


.close