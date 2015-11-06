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

.openfile VF03.BIN, 0x8015DC50

.org 0x80161989

	.byte 0xD

.close
