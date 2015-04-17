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

.psx
.align 4

.openfile VA11.BIN, 0x8010DC50

;Minotaurus Name
.org 0x8013F470
.area 0x8013F47F-.
minotaurus:
	.byte 0x47
	.byte 0x19
	.byte 0x1E
	.byte 0x1F
	.byte 0x24
	.byte 0x11
	.byte 0x25
	.byte 0x22
	.byte 0x25
	.byte 0x23
	.byte 0x00
.endarea

;Magus Name
.org 0x80141F64
.area 0x80141F73-.
magus:
	.byte 0x47
	.byte 0x11
	.byte 0x17
	.byte 0x25
	.byte 0x23
	.byte 0x00
	.byte 0x00
	.byte 0x00
	.byte 0x00
.endarea

;Chimera Name
.org 0x80145548
.area 0x80145557-.
Chimera:
	.byte 0x3D
	.byte 0x18
	.byte 0x19
	.byte 0x1D
	.byte 0x15
	.byte 0x22
	.byte 0x11
	.byte 0x00
	.byte 0x00
.endarea

;Add Chimera Parties to Encounter Table
.org 0x801363D4
.area 0x801363FC-.
encounters:
	.word 0x801362D4
	.word 0x8013637C
	.word 0x801362F0
	.word 0x80136398
	.word 0x8013630C
	.word 0x80136328
	.word 0x801363B4
	.word 0x80136344
	.word 0x80136344
	.word 0x80136360
.endarea


.close