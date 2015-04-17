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
	.word 0x801362D4, 0x8013637C, 0x801362F0, 0x80136398, 0x8013630C, 0x80136328,
	.word 0x801363B4, 0x80136344, 0x80136344, 0x80136360
.endarea


.close