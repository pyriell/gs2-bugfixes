; Suikoden II Two River Battle Crash
; Written by Pyriel
;
; Fixes an issue with the translation that causes a crash during the Highland attack on Two River.
; One of the options was extended to a third line in the German text, pushing the choices beyond
; the size allowed by the game.  When the last option is selected, it returns an option number
; not allowed by the script, resulting in a crash when no scripting is found to handle the player's
; choice.
;
; Changing the last newline character in the string to a space fixes the issue, and the text
; has plenty of space left before it would overflow the right margin of the box.
;
; So far as I know, only VH12.BIN is used during these events, but the string is changed in all
; files that contain it, just in case.

.psx
.openfile VH01.BIN, 0x8010DC50
.align 4

.org 0x80117CCF
.byte 0x10

.close

.openfile VH06.BIN, 0x8010DC50
.align 4

.org 0x80114CFF
.byte 0x10

.close

.openfile VH07.BIN, 0x8015DC50
.align 4

.org 0x8016172B
.byte 0x10

.close

.openfile VH08.BIN, 0x8015DC50
.align 4

.org 0x801613E3
.byte 0x10

.close

.openfile VH11.BIN, 0x8015DC50
.align 4

.org 0x801677BB
.byte 0x10

.close

.openfile VH12.BIN, 0x8010DC50
.align 4

.org 0x80111997
.byte 0x10

.close
