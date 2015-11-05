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

.openfile VF05.BIN, 0x8010DC50

.org 0x801104A4
tabptr:
	.word 0x8015CF44	;change the text table pointer

.org 0x8015CF44
pointers:
	.word 0x80115C9C	;relocate all the text pointers to the end of the file.
	.word 0x80115CE8	;space is too tight in the original location.
	.word 0x80115D10
	.word 0x80115D4C
	.word 0x80115D6C
	.word 0x80115DA0
	.word 0x80115DC8
	.word 0x80115E14
	.word 0x80115E78
	.word 0x80115EA0
	.word 0x80115ED0
	.word 0x80115EEC
	.word 0x80115F1C
	.word 0x80115F30 
	.word 0x80115F4C
	.word 0x80115FA4
newvals:
	.word 0x80116020
	.word 0x80116064
	.word 0x801160A4
	.word 0x801160EC
	.word 0x80116140
	.word 0x80116194
.close
