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
	.word 0x80135FD8
	.word 0x80136080		; change
	.word 0x80135FF4
	.word 0x8013609C		; change
	.word 0x80136010
	.word 0x8013602C		
	.word 0x801360B8		; change
	.word 0x80136048
	.word 0x80136048
	.word 0x80136064
.endarea


.close